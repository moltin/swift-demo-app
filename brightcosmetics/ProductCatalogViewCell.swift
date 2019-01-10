//
//  ProductCatalogViewCell.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import UIKit

class ProductCatalogViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productCatalogImages: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var productDescLabel: UILabel!
    
    
    
    func displayProducts(image: String, title: String, desc: String, price: String) {
        self.productLabel.text = title
        self.imageBackground.backgroundColor = Colors.imageBackground()
        self.productCatalogImages.load(urlString: image)
        self.productDescLabel.text = price
        self.productDescLabel.textColor = Colors.lightGreyText()
    }
    
    
}
