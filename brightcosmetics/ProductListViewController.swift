//
//  ProductListViewController.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import moltin


class ProductListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var productCollectionView: UICollectionView!
    var productList: [moltin.Product] = []

    @IBOutlet weak var titleLabel: UINavigationBar!
    
    override func viewDidLoad() {
        UINavigationBar.appearance().barTintColor = Colors.navBar()

        super.viewDidLoad()
        //may be worth fetching the products via catalouge filter
        self.titleLabel.topItem?.title = self.productList[0].categories![0].name
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCatalogViewCell", for: indexPath)
            as! ProductCatalogViewCell
        cell.displayProducts(image: self.productList[indexPath.row].mainImage?.link["href"] ?? "", title: self.productList[indexPath.row].name, desc: self.productList[indexPath.row].description, price: self.productList[indexPath.row].meta.displayPrice?.withTax.formatted ?? "")
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //go to product detail
        let product = self.productList[indexPath.row]

        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailController = Storyboard.instantiateViewController(withIdentifier:"ProductDetail") as? ProductDetailViewController
        detailController?.product = product
        self.present(detailController!, animated: true, completion: nil)
    }

}
