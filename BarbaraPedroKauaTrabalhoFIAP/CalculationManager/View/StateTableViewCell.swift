//
//  StateTableViewCell.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 31/12/20.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var stateNameLbl: UILabel?
    @IBOutlet weak var taxPriceLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    func configureCell(with state:State) {
        stateNameLbl?.text = state.name
        taxPriceLbl?.text = String(state.tax)
    }
    
}
