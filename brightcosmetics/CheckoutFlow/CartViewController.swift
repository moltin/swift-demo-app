//
//  CartViewController.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit
import moltin

class CartViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountInCartLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var keepShoppingButtonLabel: UIButton!
    @IBOutlet weak var checkoutButtonLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cartDetailsView: UIView!
    var cartItems: [moltin.CartItem] = Array()
    var productsInCart: [moltin.Product] = Array()

    @IBOutlet weak var topTitleBoarder: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutButtonLabel.backgroundColor = Colors.buttonColor()
        checkoutButtonLabel.layer.cornerRadius = 25
        checkoutButtonLabel.setTitleColor(UIColor.white, for: .normal)
        
        keepShoppingButtonLabel.backgroundColor = UIColor.white
        keepShoppingButtonLabel.layer.cornerRadius = 25
        keepShoppingButtonLabel.setTitleColor(UIColor.black, for: .normal)
        keepShoppingButtonLabel.layer.borderWidth = 2.0
        keepShoppingButtonLabel.layer.borderColor = Colors.buttonColor().cgColor
        keepShoppingButtonLabel.setTitleColor(Colors.buttonColor(), for: .normal)
        
        cartDetailsView.layer.addBorder(edge: .top, color: Colors.lightGreyText(), thickness: 1.0)

        topTitleBoarder.layer.addBorder(edge: .top, color: Colors.lightGreyText(), thickness: 1.0)
        
        amountInCartLabel.backgroundColor = Colors.buttonColor()
        amountInCartLabel.layer.cornerRadius = 90
        amountInCartLabel.textColor = UIColor.white
        
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        self.tableView.rowHeight = 100.0
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        //fetch cart
        
        
        MoltinManager.instance().getCart(cartId: "") { (cart) -> (Void) in
            self.amountLabel.text = "Subtotal: \(cart?.meta?.displayPrice.withTax.formatted ?? "")"
        }

        //TODO: return cartItems and products fetch cartItems
        MoltinManager.instance().getCartItems(cartId: "") { (cartItems) -> (Void) in
            self.cartItems = cartItems
        
        let productIds = self.cartItems.map({ $0.productId })
        
        for id in productIds {
            MoltinManager.instance().getProductById(productId: id) { (product) -> (Void) in
                 let productItem = product
                self.productsInCart.insert(productItem!, at: self.productsInCart.endIndex)
                self.tableView.reloadData()
            }
        }
            self.amountInCartLabel.text = String(self.cartItems.count)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func keepShoppingPressed(_ sender: Any) {
        //Navigate to add to cart
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CatalogView") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func checkoutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "cartToCheckoutDetail", sender: nil)
    }
    
    
}

    extension CartViewController:  UITableViewDataSource, CartTableViewCellDelegate, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.cartItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
            let cartItem = self.cartItems[indexPath.row]
            let cartProduct: Product = self.productsInCart[indexPath.row]
            cell.delegate = self
            cell.displayProducts(cartProduct: cartItem, product: cartProduct)
            
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let title = "Click checkout to test order"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        func cartTableViewCellDidTapTrash(_ sender: CartTableViewCell) {
            guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
            
            // Delete the row
            MoltinManager.instance().removeItemFromCart(cartId: "", productId: self.cartItems[tappedIndexPath.row].id) { () -> (Void) in
                print("Item removed")
                self.tableView.reloadData()
            }

            self.cartItems.remove(at: tappedIndexPath.row)
            tableView.deleteRows(at: [tappedIndexPath], with: .automatic)
            
            MoltinManager.instance().getCartItems(cartId: ""){ (cartItems) -> (Void) in
                self.cartItems = cartItems
                self.amountInCartLabel.text = String(self.cartItems.count)

                    MoltinManager.instance().getCart(cartId: "") { (cart) -> (Void) in
                        self.amountLabel.text = "Subtotal: \(cart?.meta?.displayPrice.withTax.formatted ?? "")"
                    }
                self.tableView.reloadData()
            }
        }
        
        func cartTableViewCellDidTapAddProduct(_ sender: CartTableViewCell) {
            guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
            // add product
            MoltinManager.instance().addItemToCart(cartId: "", productId: self.productsInCart[tappedIndexPath.row].id, qty: 1) { (itemAdded) -> (Void) in
                if itemAdded {
                    MoltinManager.instance().getCartItems(cartId: ""){ (cartItems) -> (Void) in
                        self.cartItems = cartItems
                        self.amountInCartLabel.text = String(self.cartItems.count)

                        MoltinManager.instance().getCart(cartId: "") { (cart) -> (Void) in
                            self.amountLabel.text = "Subtotal: \(cart?.meta?.displayPrice.withTax.formatted ?? "")"
                        }
                        self.tableView.reloadData()
                    }
                }
                else
                {
                    //throw some error
                    
                }
            }
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 180.0
        }
        
        
        
}

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
