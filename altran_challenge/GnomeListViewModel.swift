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
    
    /// Notifies the view when there is no data to show on the table view
    func showEmtpyListView()
    
    /// Notifies the view when the HTTP Get and save to core data has finished
    func didFinishLoading()
    
    /// Notifies the view to show an error
    ///
    /// - Parameter message: error message to present
    func showError(withMessage message: String)
    
    /// Notifies the view that a new object has been inserted in the fetchedResultsController
    ///
    /// - Parameters:
    ///   - newObject: object inserted
    ///   - newIndexPath: at indexpath that was inserted
    func didInsert(newObject:Gnome, at newIndexPath: IndexPath)
    
    /// Notifies the view that an object inside the fetchedResultsController has been updated
    ///
    /// - Parameters:
    ///   - object: updated object
    ///   - indexPath: at indexpath
    func didUpdate(object:Gnome, at indexPath: IndexPath)
    
    /// Notifies the view that NSFetchedResultsController will change
    func beginUpdates()
    
    /// Notifies the view that NSFetchedResultsController did change
    func endUpdates()
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

// MARK: - ViewModelTableViewProvide
extension GnomeListViewModel: ViewModelTableViewProvider {
    typealias Entity = Gnome
    
    var datasource: [Gnome]? {
        return fetchedResultsController.fetchedObjects as? [Gnome]
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
        
        let hasLoadedObjects = hasObjects(in: fetchedResultsController.fetchedObjects)
        
        if (!hasLoadedObjects) {
            delegate.showEmtpyListView()
        }
        
        NetworkManager.get(url: URL(string: Constants.Routes.gnomeInfo)!) { (json, error) in
            
            // notify about the error on an alert only if there is no data being shown
            if let error = error, hasLoadedObjects {
                return self.delegate.showError(withMessage: error.localizedDescription)
            }
            
            guard let gnomeList = json else {
                return self.delegate.showError(withMessage: "Error on HTTP Get Response!")
            }
            
            self.saveList(gnomeList: gnomeList)
        }
    }
    
    /// Filters fetchedResultsController based on the selected Filter
    ///
    /// - Parameter filter: filter to apply
    func filter(using filter: Constants.Filter) {
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
                DispatchQueue.main.async{
                    self.delegate.shouldReloadTableView()
                }
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
    func hasObjects<T>(in objectArray: [T]?) -> Bool {
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
            
            self.delegate.didFinishLoading()
        }
    }
    
    /// Generates de NSPredicate to filter the NSFetchedResultsController. In case filter is All, returns nil.
    ///
    /// - Parameter filter: filter to be applied
    /// - Returns: NSPredicate
    func predicate(for filter: Constants.Filter) -> NSPredicate? {
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








