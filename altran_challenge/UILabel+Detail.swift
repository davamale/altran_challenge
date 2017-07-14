//
//  UILabel+Detail.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import UIKit

extension UILabel {
    
    static func detailLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = .defaultDarkGray
        
        return label
    }
}
