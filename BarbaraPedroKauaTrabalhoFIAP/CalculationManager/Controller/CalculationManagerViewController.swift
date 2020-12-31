//
//  CalculationManagerViewController.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 31/12/20.
//

import UIKit

class CalculationManagerViewController: UIViewController {
    
    @IBOutlet weak var dolarValueTxt: UITextField?
    @IBOutlet weak var iofValueTxt: UITextField?
    @IBOutlet weak var statesListTableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statesListTableView?.delegate = self
        statesListTableView?.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addNewStateAndTax(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalculationManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
