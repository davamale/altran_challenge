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
    
    /// Device constants
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
                return .defaultDarkGray
                
            case .pink:
                return .defaultPink

            }
        }
    }
    
    /// Represents all possible filters in list view controller
    ///
    /// - all: all gnomes
    /// - noFriends: only gnomes with no friends
    /// - noProfession: only gnomes with no profession
    enum Filter: Int {
        case all
        case noFriends
        case noProfession
        
        func filterKeyName() -> String {
            switch self {
                
            case .all:
                return ""
                
            case .noFriends:
                return "hasFriends"
                
            case .noProfession:
                return "hasProfessions"
            }
        }
    }
    
    //MARK: - GnomeDetailViewController
    /// Constants related to tableView
    struct DetailTableView {
        static let imageViewpadding: CGFloat = 3
        static let professionCellHeight: CGFloat = 60
        static let professionCellIdentifier = "ProfessionCell"
        
        enum Section: Int {
            case profession
            case friend
            
            static func section(for index: Int) -> Section? {
                return Section(rawValue: index)
            }
        }
    }
    
}
