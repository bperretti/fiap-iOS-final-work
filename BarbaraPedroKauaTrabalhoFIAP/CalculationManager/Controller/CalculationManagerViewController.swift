//
//  CalculationManagerViewController.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 31/12/20.
//

import UIKit
import CoreData

protocol StatesDelegate: NSObject {
    func updateProductState(_ statesList: [State])
}

class CalculationManagerViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var dolarValueTxt: UITextField?
    @IBOutlet weak var iofValueTxt: UITextField?
    @IBOutlet weak var statesListTableView: UITableView?
    
    // MARK: - Properties
    var statesList: [State] = [] {
        didSet {
            delegate?.updateProductState(statesList)
        }
    }
    weak var delegate: StatesDelegate?
    private var userDefault = UserDefaults.standard
    private let defaultStringValue = "0.0"
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerStateCellNib()
        
        self.setupView()
        
        statesListTableView?.delegate = self
        statesListTableView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadStates()
        self.getFromUserDefault()
    }
    
    
    // MARK: - Methods
    private func setupView() {
        let doneBtn = UIBarButtonItem(title: GeneralStringUtils.doneText.rawValue, style: .done, target: self, action: #selector(self.doneButtonAction))
        let doneBtn2 = UIBarButtonItem(title: GeneralStringUtils.doneText.rawValue, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        iofValueTxt?.addDoneButtonOnKeyboard(with: doneBtn)
        dolarValueTxt?.addDoneButtonOnKeyboard(with: doneBtn2)
    }
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescription: NSSortDescriptor = NSSortDescriptor(key: CoreDataStringUtils.nameSort.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        do {
            statesList = try context?.fetch(fetchRequest) ?? []
            self.statesListTableView?.reloadData()
        } catch {
            print(CoreDataStringUtils.errorState.rawValue)
        }
    }
    
    private func registerStateCellNib() {
        self.statesListTableView?.register(UINib(nibName: NibCellStringUtils.StateTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifiersStringUtils.stateCellIdentifier.rawValue)
    }
    
    @objc
    func doneButtonAction() {
        self.dolarValueTxt?.resignFirstResponder()
        self.iofValueTxt?.resignFirstResponder()
        self.saveUserDefault()
    }
    
    private func showStateAlert(for state: State? = nil) {
        let title = state == nil ? GeneralStringUtils.addStateText.rawValue : GeneralStringUtils.editStateText.rawValue
        let titleBtn = state == nil ? GeneralStringUtils.addText.rawValue : GeneralStringUtils.editText.rawValue
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = GeneralStringUtils.nameStateText.rawValue
            nameTextField.keyboardType = .alphabet
            nameTextField.text = state?.name
        }
        
        alert.addTextField { (taxPriceTextField) in
            taxPriceTextField.placeholder = GeneralStringUtils.taxText.rawValue
            taxPriceTextField.keyboardType = .decimalPad
            if let tax = state?.tax {
                taxPriceTextField.text = String(tax)
            }
        }
        
        let okAction = UIAlertAction(title: titleBtn, style: .default) { (_) in

            if let textFields = alert.textFields, textFields.count > 1, let firstText = textFields.first?.text, !firstText.isEmpty {
                
                guard let context = self.context else { return }
                let state = state ?? State(context: context)
                state.name = firstText
                state.tax = ((textFields[1].text ?? self.defaultStringValue) as NSString).floatValue
                
                do {
                    try self.context?.save()
                    self.loadStates()
                } catch {
                    print(CoreDataStringUtils.errorState.rawValue)
                }
            }
        }
        alert.addAction(okAction )
        
        let cancelAction = UIAlertAction(title: GeneralStringUtils.cancelText.rawValue, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func saveUserDefault() {
        userDefault.set(dolarValueTxt?.text, forKey: UserDefaultStringUtils.dolarValue.rawValue)
        userDefault.set(iofValueTxt?.text, forKey: UserDefaultStringUtils.iofValue.rawValue)
    }
    
    private func getFromUserDefault() {
        userDefault.synchronize()
        self.iofValueTxt?.text = userDefault.string(forKey: UserDefaultStringUtils.iofValue.rawValue)
        self.dolarValueTxt?.text = userDefault.string(forKey: UserDefaultStringUtils.dolarValue.rawValue)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.saveUserDefault()
    }
    
    // MARK: - IBAction
    @IBAction func addNewStateAndTax(_ sender: Any) {
        self.showStateAlert()
    }
    
}

extension CalculationManagerViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statesList.count > 0 {
            self.statesListTableView?.backgroundView = nil
            self.statesListTableView?.separatorStyle = .singleLine
        } else {
            self.statesListTableView?.backgroundView = UILabel().emptyList
            self.statesListTableView?.separatorStyle = .none
        }
        return statesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersStringUtils.stateCellIdentifier.rawValue, for: indexPath) as? StateTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(with: statesList[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showStateAlert(for: statesList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: GeneralStringUtils.deleteText.rawValue) { (action, view, completionHandler) in
            let state = self.statesList[indexPath.row]
            
            self.context?.delete(state)
            do {
                try self.context?.save()
            } catch {
                print(CoreDataStringUtils.errorStateDelete.rawValue)
            }
            
            self.statesList.remove(at: indexPath.row)
            self.statesListTableView?.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
