//
//  String+Color.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import UIKit

extension String {
    
    /// Translates hair color string to UIColor
    ///
    /// - Returns: UIColor related to value
    func hairColor() -> UIColor {
        return Constants.HairColor(rawValue:self) != nil ? Constants.HairColor(rawValue:self)!.color() : UIColor.defaultBlue
    }
    
}
