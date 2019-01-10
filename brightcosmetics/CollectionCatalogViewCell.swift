//
//  CollectionCatalogViewCell.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/12/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import UIKit

class CollectionCatalogViewCell: UICollectionViewCell {

    @IBOutlet weak var productCatalogImages: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var imageBackground: UIView!
    
    
    func displayCatalogProducts(image: String, title: String, price: String ) {
        self.imageBackground.backgroundColor = Colors.imageBackground()
        self.productPrice.text = price
        self.productPrice.textColor = Colors.lightGreyText()
        self.productCatalogImages.load(urlString: image)
        self.productLabel.text = title
    }
    
    
}
