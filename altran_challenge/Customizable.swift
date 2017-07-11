//
//  Customizable.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit

/// Must be adopted by all container with customizable capabilities and a superview of UIViews.
protocol Customizable: class {
    
    /// Should be called for customization.
    func prepareUI()
    
    /// Called to add subviews constraints. (optional)
    func addContraints()
}

/// default implementation
extension Customizable {
    
    func addContraints() {}
    
    func prepareUI() {}
    
}
