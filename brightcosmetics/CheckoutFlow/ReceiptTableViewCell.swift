//
//  ReceiptTableViewCell.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/25/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import moltin

class ReceiptTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productQty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func displayProducts(cartProduct: moltin.CartItem, product: moltin.Product) {
        self.imageBackground.backgroundColor = Colors.imageBackground()
        
        //TODO get product images and size handle qty
        self.productName.text = cartProduct.name
        self.productAmount.text = cartProduct.meta.displayPrice.withTax.value.formatted
        //TODO size
        //        self.productSize.text = product.meta.variationMatrix[0]
        self.productImage.load(urlString: product.mainImage?.link["href"] ?? "")
    }
    
}


