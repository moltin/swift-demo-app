//
//  HomeViewController.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/12/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var browseCatalogButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var moreInformation: UIButton!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = Colors.navBar()
        browseCatalogButton.backgroundColor = Colors.buttonColor()
        browseCatalogButton.layer.cornerRadius = 25
        browseCatalogButton.setTitleColor(UIColor.white, for: .normal)
        moreInformation.backgroundColor = Colors.buttonColor()
        moreInformation.setTitleColor(UIColor.white, for: .normal)

        moreInformation.layer.cornerRadius = 25
        
        
        self.bottomView.clipsToBounds = true
        self.bottomView.layer.cornerRadius = 10
        self.bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.titleLabel.text = "Bright Cosmetics"
        self.subTitleLabel.text = "Be Inspired By Our Wide Selection Of Luxury Cosmetics At Affordable Prices."
        self.subTitleLabel.textColor = Colors.lightGreyText()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "homeToCatalog", sender: nil)

    }
    
}

