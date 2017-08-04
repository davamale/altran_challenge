//
//  DashboardViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import Foundation
import CoreData

enum TableViewAction: Equatable {
  
  case insert(gnome: Gnome, indexPath: IndexPath)
  case update(gnome: Gnome, indexPath: IndexPath)
  case reload
  case beginUpdates
  case endUpdates
  case finishedLoading
  case showEmptyView
  case none
  
  public static func ==(lhs: TableViewAction, rhs: TableViewAction) -> Bool {
    switch (lhs, rhs) {
    case (finishedLoading, finishedLoading):
      return true
    case (reload, reload):
      return true
    case (beginUpdates, beginUpdates):
      return true
    case (endUpdates, endUpdates):
      return true
    case (none, none):
      return true
    case (showEmptyView, showEmptyView):
      return true
    case (let .insert(lhsGnome, lhsIndexPath), let insert(rhsGnome, rhsIndexPath)):
      return lhsGnome == rhsGnome && lhsIndexPath == rhsIndexPath
    case (let update(lhsGnome, lhsIndexPath), let insert(rhsGnome, rhsIndexPath)):
      return lhsGnome == rhsGnome && lhsIndexPath == rhsIndexPath
      
    default: return false
    }
  }
}

struct Action {
  var tableViewAction: TableViewAction
  var alertMessage: String?
}

final class GnomeListViewModel: NSObject {
  
  // MARK: - Properties
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
    
    let frc = NSFetchedResultsController(fetchRequest: Gnome.sortedFetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    
    return frc
  }()
  
  var action: Action = Action(tableViewAction: .none, alertMessage: nil) {
    didSet {
      closure(action)
    }
  }
  
  let closure: ((Action) -> Void)
  
  init(closure: @escaping ((Action) -> Void)) {
    self.closure = closure
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
  func viewDidLoad() {
    
    fetch()
    handleGetList()
  }
  
  /// HTTP Get gnome info list.
  func handleGetList() {
    
    let hasLoadedObjects = hasObjects(in: fetchedResultsController.fetchedObjects)
    
    if (!hasLoadedObjects) {
      action.tableViewAction = .showEmptyView
    }
    
    NetworkManager.get(url: URL(string: Constants.Routes.gnomeInfo)!) { (json, error) in
      
      // notify about the error on an alert only if there is no data being shown
      if let error = error, hasLoadedObjects {
        return self.action.alertMessage = error.localizedDescription
      }
      
      guard let gnomeList = json else {
        return self.action.alertMessage = "Error on HTTP Get Response!"
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
          self.action.tableViewAction = .reload
        }
      }
      
    } catch {
      let fetchError = error as NSError
      self.action.alertMessage = fetchError.localizedDescription
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
      
      DispatchQueue.main.async {
        self.action.tableViewAction = .finishedLoading
      }
      
    }
  }
  
  /// Generates de NSPredicate to filter the NSFetchedResultsController. In case filter is All, returns nil.
  ///
  /// - Parameter filter: filter to be applied
  /// - Returns: NSPredicate
  func predicate(for filter: Constants.Filter) -> NSPredicate? {
    return filter == .all ? nil : NSPredicate(format: "%K = false",
                                              filter.filterKeyName())
  }
}

// MARK: - NSFetchedResultsController Delegate
extension GnomeListViewModel: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    action.tableViewAction = .beginUpdates
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
      
    case .insert:
      guard let gnomeObject = anObject as? Gnome,
        let newIndexPath = newIndexPath else { return }
      action.tableViewAction = .insert(gnome: gnomeObject,
                                       indexPath: newIndexPath)
      break
      
    case .update:
      guard let gnomeObject = anObject as? Gnome,
        let indexPath = indexPath else { return }
      action.tableViewAction = .update(gnome: gnomeObject,
                                       indexPath: indexPath)
      break
      
    default:
      break
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    action.tableViewAction = .endUpdates
  }
}








