//
//  UIImageView+NetworkManager.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import UIKit

extension UIImageView {
    
    /// Loads images asyncronously.
    ///
    /// - Parameters:
    ///   - urlString: url to download the image
    ///   - completion: optional UIImage
    func loadImage(from urlString: String, with completion:((UIImage?) -> ())? = nil) {
        
        if let cachedImage = NetworkManager.shared.cacheImage(for: urlString as AnyObject) {
            DispatchQueue.main.async {
                self.image = cachedImage
                if let completion = completion {
                    return completion(cachedImage)
                }
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
            if let completion = completion {
                return completion(image)
            }
        }
        
    }
    
}
