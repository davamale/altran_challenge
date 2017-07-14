//
//  ViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import UIKit

/// <#Description#>
protocol ViewModel {}

/// <#Description#>
protocol ViewModelTableViewProvider: ViewModel {
    
    associatedtype Entity
    
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

// MARK: - <#Description#>
extension ViewModelTableViewProvider {
    
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




