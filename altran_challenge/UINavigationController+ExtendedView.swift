//
//  UINavigationController+ExtendedView.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import UIKit

extension UINavigationBar {
    
    /// hides hairline at the bottom of the navigationbar
    func removeHairline() {
        isTranslucent = false
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
}
