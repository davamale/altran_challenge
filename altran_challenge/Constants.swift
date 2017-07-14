//
//  Constants.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit

struct Constants {
    
    struct Routes {
        static let gnomeInfo = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    }
    
    struct Device {
        
        /// Navigation bar height
        static let navigationBarHeight: CGFloat = 44.0
        
        /// Status bar height
        static let statusBarHeight: CGFloat = 20.0
        
        /// Navigation bar + Status bar height
        static let navigationBarStatusBarHeight = navigationBarHeight + statusBarHeight
    }
    
    /// Enum for Gnomes hair colors
    enum HairColor: String {
        
        case black = "Black"
        case red = "Red"
        case green = "Green"
        case gray = "Gray"
        case pink = "Pink"
        
        func color() -> UIColor {
            switch self {
            case .black:
                return .defaultBlack
                
            case .red:
                return .defaultRed
                
            case .green:
                return .defaultGreen
                
            case .gray:
                return .defaultGray
                
            case .pink:
                return .defaultPink

            }
        }
        
    }
    
}
