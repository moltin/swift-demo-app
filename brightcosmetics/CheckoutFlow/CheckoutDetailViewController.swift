//
//  CheckoutDetailViewController.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit

class CheckoutDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var nameField: UIView!
    @IBOutlet weak var emailField: UIView!
    @IBOutlet weak var continuePaymentButton: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.backgroundColor = Colors.buttonColor()

        nameField.layer.cornerRadius = 15.0
        nameField.layer.borderWidth = 2.0
        nameField.layer.borderColor = Colors.buttonOutlineGrey().cgColor
        emailField.layer.cornerRadius = 15.0
        emailField.layer.borderWidth = 2.0
        emailField.layer.borderColor = Colors.buttonOutlineGrey().cgColor
        
        continuePaymentButton.backgroundColor = Colors.buttonColor()
        continuePaymentButton.layer.cornerRadius = 25
        continuePaymentButton.setTitleColor(UIColor.white, for: .normal)
        continuePaymentButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        //create user or pass to payment
        MoltinManager.instance().createCustomer(userName: self.nameTextInput?.text ?? "", userEmail: self.emailTextInput?.text ?? "")
        
        let Storyboard = UIStoryboard.init(name: "CheckoutFlow", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier:"CheckoutPayment") as? CheckoutPaymentViewController
        vc?.customerName = self.nameTextInput.text ?? "no name"
        self.present(vc!, animated: true, completion: nil)

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let Storyboard = UIStoryboard.init(name: "CheckoutFlow", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier:"CartView") as? CartViewController
        self.present(vc!, animated: true, completion: nil)
    }
    
    

}
