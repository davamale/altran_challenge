//
//  CellProtocol.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import UIKit

protocol CellProtocol: class {
    
    /// UINib for UITableViewCell
    static var nib: UINib { get }
    
    /// CellIdentifier string for UITableViewCell
    static var identifier: String { get }
    
    /// ClassName string for UITableViewCell
    static var className: String { get }
    
    /// Populates cell with entity info.
    ///
    /// - Parameter entity: entity to populate the cell
    /// - Returns: UITableViewCell subclass
    func configure<Entity>(withEntity entity: Entity) -> Self
}

extension CellProtocol where Self: UITableViewCell {
    
    static var className: String {
        return String(describing:Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
    
    static var identifier: String {
        return "\(className)Identifier"
    }
    
}
