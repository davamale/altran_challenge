//
//  UILabel+Detail.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import UIKit

extension UILabel {
    
    /// Create a UILabel instance with the style used in detail view controller
    ///
    /// - Returns: UILabel instance with style
    static func detailLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = .defaultDarkGray
        
        return label
    }
}
