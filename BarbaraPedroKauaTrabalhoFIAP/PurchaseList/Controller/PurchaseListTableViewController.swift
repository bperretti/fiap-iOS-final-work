//
//  PurchaseListTableViewController.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 30/12/20.
//

import UIKit
import CoreData

class PurchaseListTableViewController: UITableViewController {
    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescription: NSSortDescriptor = NSSortDescriptor(key: CoreDataStringUtils.nameSort.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        guard let context = context else { return NSFetchedResultsController() }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadProducts()
    }
    
    // MARK: - Methods
    private func loadProducts() {
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count > 0 ? nil : UILabel().emptyList
        return count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersStringUtils.purchaseCellIdentifier.rawValue, for: indexPath) as? PurchaseTableViewCell else  { return UITableViewCell() }
        
        let product = fetchedResultsController.object(at: indexPath)
        cell.configureCell(with: product)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultsController.object(at: indexPath)
            context?.delete(product)
            do {
                try context?.save()
            } catch {
                print(CoreDataStringUtils.errorProductDelete.rawValue)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addEditVC = segue.destination as? AddEditProductViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
        
        addEditVC.product = fetchedResultsController.object(at: indexPath)
    }
}

extension PurchaseListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
