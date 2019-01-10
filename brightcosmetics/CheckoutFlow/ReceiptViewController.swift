//
//  ReceiptViewController.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import moltin

class ReceiptViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var cartItems: [moltin.CartItem] = Array()
    var productsInCart: [moltin.Product] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: return cartItems and products fetch cartItems
        MoltinManager.instance().getCartItems(cartId: ""){ (cartItems) -> (Void) in
            self.cartItems = cartItems
            let productIds = self.cartItems.map({ $0.productId })
            
            for id in productIds {
                MoltinManager.instance().getProductById(productId: id) { (product) -> (Void) in
                    let productItem = product
                    self.productsInCart.insert(productItem!, at: self.productsInCart.endIndex)
                    self.tableView.reloadData()
                }
            }
            
            MoltinManager.instance().getCart(cartId: "") { (cart) -> (Void) in
                self.totalLabel.text = cart?.meta?.displayPrice.withTax.formatted
            }
        }

        self.totalLabel.textColor = Colors.lightGreyText()
        tableView.register(UINib(nibName: "ReceiptTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiptCell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MoltinManager.instance().deleteCart(cartId: "") { () -> (Void) in
            print("Cart removed")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeController = Storyboard.instantiateViewController(withIdentifier:"Home") as? HomeViewController
        self.present(homeController!, animated: true, completion: nil)
    }
    

}

extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptTableViewCell
        let cartItem = self.cartItems[indexPath.row]
        let cartProduct: Product = self.productsInCart[indexPath.row]
        cell.displayProducts(cartProduct: cartItem, product: cartProduct)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }

}
