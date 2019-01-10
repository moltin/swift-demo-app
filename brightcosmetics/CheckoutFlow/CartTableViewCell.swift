//
//  CartTableViewCell.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import moltin

protocol CartTableViewCellDelegate : class {
    func cartTableViewCellDidTapTrash(_ sender: CartTableViewCell)
    func cartTableViewCellDidTapAddProduct(_ sender: CartTableViewCell)
}


class CartTableViewCell: UITableViewCell {
    
    weak var delegate: CartTableViewCellDelegate?

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDetail: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQty: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    var cartCellItem: moltin.CartItem?
    var productCellItem: moltin.Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayProducts(cartProduct: moltin.CartItem, product: moltin.Product) {
        self.cartCellItem = cartProduct
        self.productCellItem = product
        
        productQty.layer.cornerRadius = 20
        productQty.clipsToBounds = true
        productQty.setTitleColor(Colors.buttonColor(), for: .normal)
        productQty.layer.borderWidth = 2.0
        productQty.layer.borderColor = Colors.lightGreyText().cgColor
        
        trashButton.layer.cornerRadius = 20
        trashButton.clipsToBounds = true
        trashButton.setTitleColor(Colors.buttonColor(), for: .normal)
        trashButton.layer.borderWidth = 2.0
        trashButton.layer.borderColor = Colors.lightGreyText().cgColor

        
        self.productQty.setTitle("x \(String(cartProduct.quantity))", for: .normal)
        
        //TODO get product images and size handle qty
        self.productName.text = cartProduct.name
        self.productDetail.text = cartProduct.description
        self.productDetail.textColor = Colors.lightGreyText()
        self.productPrice.text = cartProduct.meta.displayPrice.withTax.value.formatted
        //TODO size
//        self.productSize.text = product.meta.variationMatrix[0]
        self.productImage.load(urlString: product.mainImage?.link["href"] ?? "")
    }

    
    
    @IBAction func trashProductPressed(_ sender: Any) {
        //remove itemx
        delegate?.cartTableViewCellDidTapTrash(self)
        
    }
    @IBAction func addQtyPressed(_ sender: Any) {
        //add qty of product
        delegate?.cartTableViewCellDidTapAddProduct(self)
    }
    
}
