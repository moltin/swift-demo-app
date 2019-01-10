//
//  Colors.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/18/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import Foundation
import UIKit
public class Colors: NSObject {
    
    static func textColor() -> UIColor {
        return UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.0)
    }
    
    static func navBar() -> UIColor {
        return UIColor(red:1.00, green:0.28, blue:0.32, alpha:1.0)
    }
    
    static func productMask() -> UIColor {
        return UIColor(red:247, green:248, blue:250, alpha:1.0)
    }
    static func imageBackground() -> UIColor {
        return UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.0)
    }
    static func lightGreyText() -> UIColor {
        return  UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)

    }
    
    static func buttonColor() -> UIColor {
        return UIColor(red:1.00, green:0.07, blue:0.49, alpha:1.0)
    }
    
    static func buttonOutlineGrey() -> UIColor {
        return UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
    }
    
}

func setGradientBackground() {
    let colorTop =  UIColor(red:1.00, green:0.07, blue:0.49, alpha:1.0).cgColor
    let colorBottom = UIColor(red:1.00, green:0.51, blue:0.15, alpha:1.0).cgColor
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
}

