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
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerStateCellNib()
        
        statesListTableView?.delegate = self
        statesListTableView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadStates()
        self.getFromUserDefault()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.saveUserDefault()
    }
    
    // MARK: - Methods
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescription: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        do {
            statesList = try context?.fetch(fetchRequest) ?? []
            self.statesListTableView?.reloadData()
        } catch {
            print("Error return states list from db")
        }
    }
    
    private func registerStateCellNib() {
        self.statesListTableView?.register(UINib(nibName: "StateTableViewCell", bundle: nil), forCellReuseIdentifier: "stateCellIdentifier")
    }
    
    private func showStateAlert(for state: State? = nil) {
        let title = state == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Nome do estado"
            nameTextField.text = state?.name
        }
        
        alert.addTextField { (taxPriceTextField) in
            taxPriceTextField.placeholder = "Imposto"
            if let tax = state?.tax {
                taxPriceTextField.text = String(tax)
            }
        }
        
        let okAction = UIAlertAction(title: title, style: .default) { (_) in
            guard let context = self.context else { return }
            let state = state ?? State(context: context)
            
            if let textFields = alert.textFields, textFields.count > 1 {
                state.name = textFields.first?.text
                state.tax = ((textFields[1].text ?? "0.0") as NSString).floatValue
            }
            
            do {
                try self.context?.save()
                self.loadStates()
            } catch {
                print("Error to save new states in bd")
            }
            
        }
        alert.addAction(okAction )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func saveUserDefault() {
        userDefault.set(dolarValueTxt?.text, forKey: "dolarValue")
        userDefault.set(iofValueTxt?.text, forKey: "iofValue")
    }
    
    private func getFromUserDefault() {
        userDefault.synchronize()
        self.iofValueTxt?.text = userDefault.string(forKey: "iofValue")
        self.dolarValueTxt?.text = userDefault.string(forKey: "dolarValue")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stateCellIdentifier", for: indexPath) as? StateTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(with: statesList[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showStateAlert(for: statesList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let state = self.statesList[indexPath.row]
            
            self.context?.delete(state)
            do {
                try self.context?.save()
            } catch {
                print("Erro in remove a state from db")
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
