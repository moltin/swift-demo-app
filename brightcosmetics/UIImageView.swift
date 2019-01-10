//
//  UIImageView.swift
//  brightcosmetics
//
//  Created by George FitzGibbons on 6/15/18.
//  Copyright © 2018 George FitzGibbons. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(urlString string: String?) {
        guard let imageUrl = string,
            let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
            }.resume()
    }
}
