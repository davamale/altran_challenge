//
//  DashboardViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import Foundation
import CoreData

protocol GnomeListViewModelDelegate: class {
    
    /// Notifies the view to reload the table view
    func shouldReloadTableView()
    
    /// Notifies the view when the HTTP Get and save to core data has finished
    func didFinishLoading()
    
    /// <#Description#>
    ///
    /// - Parameter message: <#message description#>
    func showError(withMessage message: String)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - newObject: <#newObject description#>
    ///   - newIndexPath: <#newIndexPath description#>
    func didInsert(newObject:Gnome, at newIndexPath: IndexPath)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - object: <#object description#>
    ///   - indexPath: <#indexPath description#>
    func didUpdate(object:Gnome, at indexPath: IndexPath)
    
    /// Notifies the view that NSFetchedResultsController will change
    func beginUpdates()
    
    /// Notifies the view that NSFetchedResultsController did change
    func endUpdates()
}

// MARK: - Enums
extension GnomeListViewModel {
    
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
}


class GnomeListViewModel: NSObject {
    
    // MARK: - Properties
    fileprivate let delegate: GnomeListViewModelDelegate!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        
        let frc = NSFetchedResultsController(fetchRequest: Gnome.sortedFetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc
    }()
    
    init(delegate: GnomeListViewModelDelegate) {
        self.delegate = delegate
        super.init()
    }
}

// MARK: - Public Methods
extension GnomeListViewModel {
    
    /// Performs initial fetch. Should be called from ViewDidLoad method.
    func initialFetch() {
        
        fetch()
        getList()
    }
    
    
    /// HTTP Get gnome info list.
    func getList() {
        
        NetworkManager.get(url: URL(string: Constants.Routes.gnomeInfo)!) { (json, error) in
            
            // notify about the error on an alert only if there is no data being shown
            if let error = error, self.hasFetchedObjects(in: self.fetchedResultsController.fetchedObjects) {
                return self.delegate.showError(withMessage: error.localizedDescription)
            }
            
            guard let gnomeList = json else {
                return self.delegate.showError(withMessage: "Error on HTTP Get Response!")
            }
            
            self.saveList(gnomeList: gnomeList)
        }
    }
    
    /// Number of sections for view
    ///
    /// - Returns: Int
    func numberOfSections() -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    /// Number of rows in Section
    ///
    /// - Parameter section: section at tableview
    /// - Returns: Int
    func numberOfRows(in section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func object(atIndexPath indexPath: IndexPath) -> Gnome? {
        return fetchedResultsController.object(at: indexPath) as? Gnome
    }
    
    /// Filters fetchedResultsController based on the selected Filter
    ///
    /// - Parameter filter: filter to apply
    func filter(using filter: Filter) {
        fetchedResultsController.fetchRequest.predicate = predicate(for: filter)
        fetch(forceReload: true)
    }
}

// MARK: - Private Methods
extension GnomeListViewModel {
    
    func fetch(forceReload: Bool? = nil) {
        do {
            try fetchedResultsController.performFetch()
            
            // reloads tableview
            if let forceReload = forceReload, forceReload {
                delegate.shouldReloadTableView()
            }
            
        } catch {
            let fetchError = error as NSError
            
            delegate.showError(withMessage: fetchError.localizedDescription)
        }
    }
    
    /// Evaluates if the objects array has objects
    ///
    /// - Parameter objectArray: object array to evaluate
    /// - Returns: Bool value indicating if it has objects
    func hasFetchedObjects<T>(in objectArray: [T]?) -> Bool {
        return objectArray != nil ? objectArray!.count > 0 : false
    }
    
    /// Saves Gnome list fetched from the HTTP Get to core data
    ///
    /// - Parameter gnomeList: JSONArray that represents Gnome list fetched
    func saveList(gnomeList: JSONArray) {
        
        DispatchQueue.global(qos: .utility).async {
            
            for gnome in gnomeList {
                let _ = Gnome.save(object: gnome)
            }
            
            CoreDataStack.shared.save()
            
            DispatchQueue.main.async {
                self.delegate.didFinishLoading()
            }
        }
    }
    
    /// Generates de NSPredicate to filter the NSFetchedResultsController. In case filter is All, returns nil.
    ///
    /// - Parameter filter: filter to be applied
    /// - Returns: NSPredicate
    func predicate(for filter: Filter) -> NSPredicate? {
        return filter == .all ? nil : NSPredicate(format: "%K = false", filter.filterKeyName())
    }
}

// MARK: - NSFetchedResultsController Delegate
extension GnomeListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let gnomeObject = anObject as? Gnome, let newIndexPath = newIndexPath else {
                return
            }
            self.delegate .didInsert(newObject: gnomeObject, at: newIndexPath)
            break
            
        case .update:
            guard let gnomeObject = anObject as? Gnome, let indexPath = indexPath else {
                return
            }
            self.delegate .didUpdate(object: gnomeObject, at: indexPath)
            break
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.endUpdates()
    }
}








