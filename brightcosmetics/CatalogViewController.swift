//
//  CatalogViewController.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/12/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import UIKit
import moltin

class CatalogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionCatalogView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var categoyNameLabel: UILabel!
    
    @IBOutlet weak var viewAllLabel3: UIButton!
    @IBOutlet weak var viewAllLabel2: UIButton!
    @IBOutlet weak var viewAll1Label: UIButton!
    @IBOutlet weak var cat3Label: UILabel!
    @IBOutlet weak var cat2Label: UILabel!
    @IBOutlet weak var cat1Label: UILabel!
    @IBOutlet weak var collectionCatalogThreeView: UICollectionView!
    @IBOutlet weak var collectionCatalogTwoView: UICollectionView!
    
    var product: [moltin.Product] = []
    var cat1Products: [moltin.Product] = []
    var cat2Products:[moltin.Product] = []
    var cat3Products: [moltin.Product] = []
    var categoryAllProducts: [moltin.Product] = []
    
    var categories: [moltin.Category] = []
    var cat1: moltin.Category!
    var cat2: moltin.Category!
    var cat3: moltin.Category!
    var categoryAll: moltin.Category!

    var navigationBarAppearace = UINavigationBar.appearance()


    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = Colors.navBar()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        self.navBarTitle.title = "Catalogue"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.viewAll1Label.setTitleColor(Colors.navBar(), for: .normal)
        self.viewAllLabel2.setTitleColor(Colors.navBar(), for: .normal)
        self.viewAllLabel3.setTitleColor(Colors.navBar(), for: .normal)

        // Do any additional setup after loading the view, typically from a nib.

        //get all cat
        MoltinManager.instance().getCategories { (categories) -> (Void) in
            self.categories = categories
            //Get the first three categories to show then lump the rest
            self.cat1 = self.categories[0]
            self.cat2 = self.categories[1]
            self.cat3 = self.categories[2]
            MoltinManager.instance().getProducts { (products) -> (Void) in
                self.product = products
                
                for products in self.product  {
                    if  (products.categories![0].name == self.categories[0].name) {
                        self.cat1Products.append(products)
                    }
                    else if (products.categories![0].name == self.categories[1].name) {
                        self.cat2Products.append(products)
                    }
                    else if (products.categories![0].name == self.categories[2].name) {
                        self.cat3Products.append(products)
                    }
                    else {
                        self.categoryAllProducts.append(products)
                    }
                }
                self.collectionCatalogView.reloadData()
                self.collectionCatalogTwoView.reloadData()
                self.collectionCatalogThreeView.reloadData()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cat1Products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Show the top 2 categories and add everthing else in the third
        if collectionView == self.collectionCatalogView {
            self.cat1Label.text = self.cat1.name
            let cell1 = collectionCatalogView.dequeueReusableCell(withReuseIdentifier: "collectionCatalogViewCell", for: indexPath)
                as! CollectionCatalogViewCell
            cell1.displayCatalogProducts(image: self.cat1Products[indexPath.row].mainImage?.link["href"] ?? "", title: self.cat1Products[indexPath.row].name, price: self.cat1Products[indexPath.row].meta.displayPrice?.withTax.formatted ?? "")
            return cell1
        }
        else if collectionView == self.collectionCatalogThreeView {
            self.cat2Label.text = self.cat2.name
            let cell2 = collectionCatalogView.dequeueReusableCell(withReuseIdentifier: "collectionCatalogViewCell", for: indexPath)
                as! CollectionCatalogViewCell
            cell2.displayCatalogProducts(image: self.cat2Products[indexPath.row].mainImage?.link["href"] ?? "", title: self.cat2Products[indexPath.row].name, price: self.cat2Products[indexPath.row].meta.displayPrice?.withTax.formatted ?? "")
            return cell2
        }
        else {
            self.cat3Label.text = "Everything"
        let cell3 = collectionCatalogTwoView.dequeueReusableCell(withReuseIdentifier: "collectionCatalogViewCell", for: indexPath)
            as! CollectionCatalogViewCell
            cell3.displayCatalogProducts(image: self.cat3Products[indexPath.row].mainImage?.link["href"] ?? "", title: self.cat3Products[indexPath.row].name, price: self.cat3Products[indexPath.row].meta.displayPrice?.withTax.formatted ?? "")
            return cell3
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Show the top 2 categories and add everthing else in the third

        //go to product Detail
        if collectionView == self.collectionCatalogView {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as? ProductDetailViewController
            vc?.product =  self.cat1Products[indexPath.row]
            self.present(vc!, animated: true, completion: nil)
        }
        else if collectionView == self.collectionCatalogThreeView {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as? ProductDetailViewController
            vc?.product =  self.cat2Products[indexPath.row]
            self.present(vc!, animated: true, completion: nil)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as? ProductDetailViewController
            vc?.product =  self.cat3Products[indexPath.row]
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func viewAll1Pressed(_ sender: Any) {
        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let listController = Storyboard.instantiateViewController(withIdentifier:"ProductList") as? ProductListViewController
        listController?.productList = self.cat1Products
        self.present(listController!, animated: true, completion: nil)
    }
    @IBAction func viewAll2Pressed(_ sender: Any) {
        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let listController = Storyboard.instantiateViewController(withIdentifier:"ProductList") as? ProductListViewController
        listController?.productList = self.cat2Products
        self.present(listController!, animated: true,completion: nil)
    }
    @IBAction func viewAll3Pressed(_ sender: Any) {
        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let listController = Storyboard.instantiateViewController(withIdentifier:"ProductList") as? ProductListViewController
        listController?.productList = self.cat3Products
        self.present(listController!, animated: true,completion: nil)
    }
    
}
