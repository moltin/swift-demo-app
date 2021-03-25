//
//  UIViewExtension.swift
//  brightcosmetics
//
//  Created by Dilip M on 25/03/21.
//  Copyright © 2021 George FitzGibbons. All rights reserved.
//

import UIKit

extension UIView {
    
    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
