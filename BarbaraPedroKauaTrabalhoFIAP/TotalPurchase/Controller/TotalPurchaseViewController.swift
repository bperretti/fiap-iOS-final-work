//
//  TotalPurchaseViewController.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 31/12/20.
//

import UIKit
import CoreData

class TotalPurchaseViewController: UIViewController {
    @IBOutlet weak var totalDollarLbl: UILabel?
    @IBOutlet weak var totalReaisLbl: UILabel?
    
    // MARK: - Properties
    private var productsList: [Product]?
    private var iofValue:Float = 0.0
    private var dollarValue:Float = 0.0
    private var userDefault = UserDefaults.standard
    private let defaultStringValue = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getIOFandDollarValue()
        self.loadProducts()
    }

    // MARK: - Methods
    private func getIOFandDollarValue() {
        userDefault.synchronize()
        self.iofValue = ((userDefault.string(forKey: UserDefaultStringUtils.iofValue.rawValue) ?? defaultStringValue) as NSString).floatValue
        self.dollarValue = ((userDefault.string(forKey: UserDefaultStringUtils.dolarValue.rawValue) ?? defaultStringValue) as NSString).floatValue
    }
    
    private func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescription: NSSortDescriptor = NSSortDescriptor(key: CoreDataStringUtils.nameSort.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        do {
            productsList = try context?.fetch(fetchRequest) ?? []
            self.calculateTotalValues()
        } catch {
            print(CoreDataStringUtils.errorState.rawValue)
        }
    }
    
    private func calculateTotalValues() {
        if let products = self.productsList, products.count > 0 {
            self.calculateDollarValue(products)
            self.calculateReaisValue(products)
        } else {
            self.totalDollarLbl?.text = defaultStringValue
            self.totalReaisLbl?.text = defaultStringValue
        }
    }
    
    private func calculateDollarValue(_ products: [Product]) {
        var totalDollar:Float = 0.0
        for product in products {
            totalDollar += product.price
        }
        
        self.totalDollarLbl?.text = String(totalDollar)
    }
    
    private func calculateReaisValue(_ products: [Product]) {
        var totalReais:Float = 0.0
        var totalProduct: Float = 0.0
        for product in products {
            totalProduct = (product.price + (product.state?.tax ?? 0.0)) * dollarValue
            if product.payWithCard {
                totalProduct += (totalProduct * (iofValue/100))
            }
            
            totalReais += totalProduct
            totalProduct = 0.0
        }
        
        self.totalReaisLbl?.text = String(totalReais)
    }
}

extension TotalPurchaseViewController: NSFetchedResultsControllerDelegate {
}
