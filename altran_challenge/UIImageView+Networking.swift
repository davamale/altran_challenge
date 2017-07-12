//
//  UIImageView+Networking.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String) {
        
        if let cachedImage = NetworkManager.shared.cacheImage(for: urlString as AnyObject) {
            DispatchQueue.main.async {
                return self.image = cachedImage
            }
        }
        
        guard let imageUrl = URL(string: urlString) else {
            return
        }
        
        let networkManager = NetworkManager.shared
        
        networkManager.loadImage(from: imageUrl) { (image, networkError) in
            if networkError != nil {
                return
            }
            
            self.image = image
            self.setNeedsDisplay()
        }
        
    }
    
}
