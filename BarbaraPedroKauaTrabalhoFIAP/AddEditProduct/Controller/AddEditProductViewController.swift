//
//  AddEditProductViewController.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 30/12/20.
//

import UIKit
import CoreData

protocol ToolbarPickerViewDelegate: NSObject {
    func didTapDone()
    func didTapCancel()
}

class AddEditProductViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameProductTxt: UITextField?
    @IBOutlet weak var nameStatetxt: UITextField?
    @IBOutlet weak var priceProductTxt: UITextField?
    @IBOutlet weak var saveProductBtn: UIButton?
    @IBOutlet weak var imageProductBtn: UIButton?
    
    // MARK: - Properties
    var product: Product?
    var imageProduct: UIImage?
    var statesList: [State] = []
    let statePickerView = UIPickerView()
    var stateSelected: State?
    weak var toolbarDelegate: ToolbarPickerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.configurePickerView()
        self.loadStates()
    }
    
    // MARK: - IBActions
    @IBAction func selectProductImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar imagem do produto", message: "De onde você gostaria de selecionar a imagem?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (_) in
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPictureFrom(.photoLibrary)
        }
        
        let photoAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (_) in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        
        alert.addAction(libraryAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil )
    }
    
    @IBAction func saveProduct(_ sender: Any) {
        if product == nil {
            guard let context = context else { return }
            product = Product(context: context)
        }
        
        product?.name = self.nameProductTxt?.text ?? ""
        product?.price = ((self.priceProductTxt?.text ?? "0.0") as NSString).floatValue
        product?.image = imageProduct?.jpegData(compressionQuality: 0.9)
        product?.state = stateSelected
        
        view.endEditing(true)
        
        do {
            try context?.save()
            navigationController?.popViewController(animated: true)
        } catch let error {
            print("error to save in db \(error.localizedDescription)")
        }
        
        
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let calculationVC = segue.destination as? CalculationManagerViewController {
            calculationVC.delegate = self
        }
    }
    
    // MARK: - Methods
    private func setupView() {
        if let product = product {
            title = "Editar Produto"
            nameProductTxt?.text = product.name
            nameStatetxt?.text = product.state?.name
            stateSelected = product.state
            priceProductTxt?.text = String(product.price)
            
            if let data = product.image {
                imageProduct = UIImage(data: data)
                imageProductBtn?.setBackgroundImage(imageProduct, for: .normal)
            }
            
            saveProductBtn?.setTitle("Editar", for: .normal)
        } else {
            title = "Cadastrar Produto"
            saveProductBtn?.setTitle("Cadastrar", for: .normal)
        }
    }
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescription: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        do {
            statesList = try context?.fetch(fetchRequest) ?? []
            self.statePickerView.reloadAllComponents()
        } catch {
            print("Error return states list from db")
        }
    }
    
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func configurePickerView() {
        statePickerView.delegate = self
        statePickerView.dataSource = self
        self.toolbarDelegate = self
        
        statePickerView.backgroundColor = .white
        statePickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        nameStatetxt?.inputView = statePickerView
        nameStatetxt?.inputAccessoryView = toolBar
        
    }
    
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}


extension AddEditProductViewController: UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statesList[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameStatetxt?.text = statesList[row].name
        stateSelected = statesList[row]
    }
    
    func didTapDone() {
        let row = self.statePickerView.selectedRow(inComponent: 0)
        self.statePickerView.selectRow(row, inComponent: 0, animated: false)
        self.nameStatetxt?.text = statesList[row].name
        stateSelected = statesList[row]
        self.nameStatetxt?.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.nameStatetxt?.text = nil
        self.nameStatetxt?.resignFirstResponder()
    }
    
}

extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Image Picker View
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageProduct = image
            imageProductBtn?.setBackgroundImage(imageProduct, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddEditProductViewController: StatesDelegate {
    func updateProductState(_ statesList: [State]) {
        self.statesList = statesList
        self.statePickerView.reloadAllComponents()
    }
}
