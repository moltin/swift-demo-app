//
//  ConfirmationTableViewCell.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/21/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import moltin

class ConfirmationTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var imageBackground: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func displayProducts(cartProduct: moltin.CartItem, product: moltin.Product) {
        self.imageBackground.backgroundColor = Colors.imageBackground()
        
        //TODO get product images and size handle qty
        self.productName.text = cartProduct.name
        self.productAmount.text = cartProduct.meta.displayPrice.withTax.value.formatted
        self.productQty.text = String(cartProduct.quantity)
        //TODO size
        //        self.productSize.text = product.meta.variationMatrix[0]
        self.productImage.load(urlString: product.mainImage?.link["href"] ?? "")
    }
    
}
