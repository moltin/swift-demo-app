# swift-demo-app
An eCommerce example App in swift


To get started with your own Moltin Store, update the client id in the Appdelegate
```
    static let moltinId = "g3hseurjGYNLzs83nRPAneJP2nDurkbkXn1901hEJP"
```

The first screen display Products within a category.  You can adjust this to fit your catalog heirarcy.  Example change the request to use brands, or simply remove it.


```
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
 ```
 
 The add to cart call, is used in multiple places but can found in the MoltinManager class.  It takes in a product and qty.  Cartid does not need to be passed in and can be left blank to be handled.
 ```
     //add item to cart
    public func addItemToCart(cartId: String?, productId: String, qty: Int, completion: @escaping (_ itemAdded: Bool) -> (Void)) {
        var itemAdded = false
        self.moltin.cart.addProduct(withID: productId , ofQuantity: qty, toCart: AppDelegate.cartID, completionHandler: { (_) in
            DispatchQueue.main.async {
                itemAdded = true
                completion(itemAdded)
            }
        })
```

Once something has been added to a cart, the check out flow is to checkout and order with customer and shipping info, then process a payment.
Example checkout used
```
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
```

From there you can look to process the order however you want.  In this example I used a manual gateway.  Not you need to enable gateways in your Moltin Store.  This can be done under settings.
```
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
  ```
