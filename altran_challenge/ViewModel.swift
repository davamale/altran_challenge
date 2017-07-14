//
//  ViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import UIKit

/// ViewModel procotol
protocol ViewModel {}

/// ViewModelTableViewProvider protocol.
protocol ViewModelTableViewProvider: ViewModel {
    
    associatedtype Entity
    
    /// Recommended to be implemented if more than one section will be used. Else will return as nil
    var datasource: [Entity]? { get }
    
    /// Number of sections. This method is required to be implemented if the table view has more than one section.
    ///
    /// - Returns: Int
    func numberOfSections() -> Int
    
    /// Number of rows in Section. This method is required to be implemented if the table view has more than one section.
    ///
    /// - Parameter section: section at tableview
    /// - Returns: Int
    func numberOfRows(in section: Int) -> Int
    
    
    /// Entity located at the given indexPath. This methods is required to be implemented if the table view has more than one section and is using NSFetchedResultsController
    ///
    /// - Parameter indexPath: location in table view
    /// - Returns: Entity associated to location
    func object(atIndexPath indexPath: IndexPath) -> Entity?
}

// MARK: - ViewModelTableViewProvider default implementation
extension ViewModelTableViewProvider {
    
    var datasource: [Entity]? {
        return nil
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return datasource != nil ? datasource!.count : 0
    }
    
    func object(atIndexPath indexPath: IndexPath) -> Entity? {
        return datasource != nil ? datasource![indexPath.row] :  nil
    }
}




