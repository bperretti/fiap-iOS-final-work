//
//  PurchaseTableViewCell.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 30/12/20.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var purchaseImageView: UIImageView?
    @IBOutlet weak var purchaseNameProductLbl: UILabel?
    @IBOutlet weak var purchasePriceLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with product: Product) {
        purchaseNameProductLbl?.text = product.name
        if let data = product.image {
            purchaseImageView?.image = UIImage(data: data)
        }
        purchasePriceLbl?.text = String(product.price)
    }
}
