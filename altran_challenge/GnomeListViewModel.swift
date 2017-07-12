//
//  DashboardViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import Foundation
import CoreData
import AndroidDialogAlert

protocol GnomeListViewModelDelegate: class {
    
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
    
    func beginUpdates()
    
    func endUpdates()
}

extension GnomeListViewModel {
    enum Filter: Int {
        case all
        case noFriends
        case noProfession
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
    
    // MARK: - Public Methods
    
    /// Performs initial fetch. Should be called from ViewDidLoad method.
    func initialFetch() {
        
        do {
            try fetchedResultsController.performFetch()
            print(fetchedResultsController.fetchedObjects ?? "Nothing")
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            
            delegate.showError(withMessage: fetchError.localizedDescription)
        }
        
        getList()
    }
    
    
    /// HTTP Get gnome info list
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
    
    // MARK: - Private Methods
    
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
        
        for gnome in gnomeList {
            let _ = Gnome.save(object: gnome)
            CoreDataStack.shared.save()
        }
        
        delegate.didFinishLoading()
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








