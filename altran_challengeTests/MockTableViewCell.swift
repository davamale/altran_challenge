//
//  MockTableViewCell.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import UIKit

class MockTableViewCell: UITableViewCell {}

extension MockTableViewCell: CellProtocol {
    /// Populates cell with entity info.
    ///
    /// - Parameter entity: entity to populate the cell
    /// - Returns: UITableViewCell subclass
    func configure<Entity>(withEntity entity: Entity) -> Self {
        return self
    }
}
