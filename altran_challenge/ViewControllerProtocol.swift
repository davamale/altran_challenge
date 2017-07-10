//
//  ViewControllerProtocol.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit

/// Must be adopted by all UIViewController sub-classes.
protocol Customizable: class {
    
    /// Should be called for UIViewController sub-class customization.
    func prepareUI()
    
    func addContraints()
}

/// UIViewControllerProtocol default implementation
extension Customizable where Self: UIViewController {
    
    func prepareUI() {
        self.view.backgroundColor = .defaultLightGray
    }
    
}
