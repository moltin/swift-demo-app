//
//  MoltinManager.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/12/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import moltin


class MoltinManager : NSObject {
    
    let moltin: Moltin = Moltin(withClientID: AppDelegate.moltinId)

    var categories: [moltin.Category] = []
    var products: [Product] = []
    var product: Product?
    var cartItems: [CartItem] = Array()
    var cart: Cart?
    

    private static let instanceVar = MoltinManager()

    private override init()
    {
        super.init();
    }
    
    static func instance() -> MoltinManager
    {
        return instanceVar
    }
    
    //Get categories
    public func getCategories(completion: @escaping (_ categories: [moltin.Category]) -> (Void)) {
        self.moltin.category.include([.products]).all(completionHandler: { (result: Result<PaginatedResponse<[moltin.Category]>>) in
            switch result {
            case .success(let response):
                self.categories = response.data ?? []
                completion(self.categories)
            case .failure(let error):
                print("Get Categories error:", error)
            }
        })
    }
    
    //Get products
    public func getProducts(completion: @escaping (_ products: [Product]) -> (Void)) {
        self.moltin.product.include([.mainImage, .categories]).all { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.products = response.data ?? []
                    completion(self.products)
                }
            case .failure(let error):
                print("Products error", error)
            }
        }
    }
    
    //get product by Id
    public func getProductById(productId: String, completion: @escaping (_ product: Product?) -> (Void)) {
        self.moltin.product.include([.mainImage]).get(forID: productId, completionHandler: { (result: Result<Product>) in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.product = product
                    completion(self.product)
                }
            default: break
            }
        })
    }
    
    //get product by Filter
    public func getProductByFilter(key: String, value: String, completion: @escaping (_ product: [moltin.Product]) -> (Void)) {
        self.moltin.product.filter(operator: .equal, key: key, value: value).include([.mainImage]).all
            { (result: Result<PaginatedResponse<[moltin.Product]>>) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.products = response.data ?? []
                        completion(self.products)
                    }
                case .failure(let error):
                    print("Get Products error:", error)
                }
        }
    }
    
    //get product by Category
    public func getProductsByCategory(categorySlug: String , completion: @escaping (_ product: [moltin.Product]) -> (Void)) {
        self.moltin.product.filter(operator: .equal, key:  "category.slug", value: categorySlug).include([.mainImage]).all
            { (result: Result<PaginatedResponse<[moltin.Product]>>) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.products = response.data ?? []
                        completion(self.products)
                    }
                case .failure(let error):
                    print("Get Products error:", error)
                }
        }
    }
    
    //MARK: CART
    //add item to cart
    public func addItemToCart(cartId: String?, productId: String, qty: Int, completion: @escaping (_ itemAdded: Bool) -> (Void)) {
        var itemAdded = false
        self.moltin.cart.addProduct(withID: productId , ofQuantity: qty, toCart: AppDelegate.cartID, completionHandler: { (_) in
            DispatchQueue.main.async {
                itemAdded = true
                completion(itemAdded)
            }
        })
    }
    
    //remove item from cart
    public func removeItemFromCart(cartId: String?, productId: String, completion: @escaping () -> (Void)) {
        self.moltin.cart.removeItem(productId, fromCart: AppDelegate.cartID, completionHandler: { (_) in
            completion()
        })
    }
    
    //get Cart Items
    public func getCartItems(cartId: String?, completion: @escaping ([moltin.CartItem]) -> (Void)) {
        self.moltin.cart.include([.products]).items(forCartID: AppDelegate.cartID) { (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.cartItems = result.data ?? []
                    completion(self.cartItems)
                }
            case .failure(let error):
                print("Cart error:", error)
            }
        }
    }
    
    //get cart
    public func getCart(cartId: String?, completion: @escaping (moltin.Cart?) -> (Void)) {
        self.moltin.cart.get(forID: AppDelegate.cartID, completionHandler: { (result)
            in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.cart = result
                    completion(self.cart)
                }
            case .failure(let error):
                print("Cart error:", error)
            }
        })
    }
    
    //delete cart: Easily remove all items from a cart.
    public func deleteCart(cartId: String?, completion: @escaping () -> (Void)) {
        self.moltin.cart.deleteCart(AppDelegate.cartID, completionHandler: { (result)
            in
            switch result {
            case .success(let result):
                completion()
                print("Cart error:", result)
            case .failure(let error):
                completion()
                print("Cart error:", error)
            }
        })
    }
    
    
    //Apply promo to cart
    
    
    //MARK: Customer
    public func createCustomer(userName: String, userEmail: String) {
        var token: String = ""
         struct moltinToken: Codable {
            var clientID: String
            var token: String
            var expires: Date
        
        }
        if let data = UserDefaults.standard.value(forKey: "Moltin.auth.credentials") as? Data {
            let credentials = try? JSONDecoder().decode(moltinToken.self, from: data)
            token = credentials?.token ?? ""
        }
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        let user = ["data": [
            "type": "customer",
            "name": userName,
            "email": userEmail,
            "password": "123456"
            ]] as [String : Any]
        
        let userData: Data
            do {
                userData = try JSONSerialization.data(withJSONObject: user, options: [])
                } catch {
                    print("Error: cannot create JSON from todo")
                    return
                }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.moltin.com/v2/customers")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = userData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }
        })
        
        dataTask.resume()
    }
    

    //MARK: Checkout
    public func payForOrder(order: Order?, paymentMethod: PaymentMethod, completion: @escaping (_ orderPayed: Bool) -> (Void)) {
        var orderPayed = false
        self.moltin.cart.pay(forOrderID: order?.id ?? "", withPaymentMethod: paymentMethod) { (result) in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    orderPayed = true
                    completion(orderPayed)
                    print("Paid for order: \(status)")
                }
            case .failure(let error):
                orderPayed = false
                completion(orderPayed)
                print("Could not pay for order: \(error)")
            }
        }
    }
    
    public func checkoutOrder(customer: Customer, address: Address, completion: @escaping (_ Order: Order) -> (Void)) {
        self.moltin.cart.checkout(cart: AppDelegate.cartID, withCustomer: customer, withBillingAddress: address, withShippingAddress: nil) { (result) in
            switch result {
            case .success(let order):
                DispatchQueue.main.async {
                    completion(order)
                }
            default: break
            }
        }
    }
    
    //MARK: Promotions
    public func applyPromotion(code: String,  completion: @escaping (_ promotionWorked: Bool) -> (Void)) {
        self.moltin.cart.addPromotion(code, toCart: AppDelegate.cartID) { (result) in
            var promotionWorked = false
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    promotionWorked = true
                    completion(promotionWorked)
                    print("Promotion: \(status)")
                }
            default: break
            }
        }
    }
}

