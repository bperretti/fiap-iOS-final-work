//
//  AddEditProductViewController.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 30/12/20.
//

import UIKit

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
    let statesPicker = [String](arrayLiteral: "Florida", "NY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        let statePickerView = UIPickerView()
        statePickerView.delegate = self
        nameStatetxt?.inputView = statePickerView
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
        
        view.endEditing(true)
        
        do {
            try context?.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("error to save in db")
        }
        
        
    }
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Methods
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupView() {
        if let product = product {
            title = "Editar Produto"
            nameProductTxt?.text = product.name
            nameStatetxt?.text = product.state?.name
            priceProductTxt?.text = String(product.price)
            if let data = product.image {
                imageProductBtn?.setBackgroundImage(UIImage(data: data), for: .normal)
            }
            saveProductBtn?.setTitle("Editar", for: .normal)
        } else {
            title = "Cadastrar Produto"
            saveProductBtn?.setTitle("Cadastrar", for: .normal)
        }
    }
}


extension AddEditProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesPicker.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statesPicker[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameStatetxt?.text = statesPicker[row]
    }
    
}

extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageProduct = image
            imageProductBtn?.setBackgroundImage(imageProduct, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
