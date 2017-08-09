//
//  GnomeDetailViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import Foundation
import CoreData

protocol GnomeDetailViewModelDelegate {
  
  /// Populates gnome info.
  ///
  /// - Parameter gnome: object used to populate the view
  func populate(with gnome: Gnome)
}

class GnomeDetailViewModel: NSObject {
  
  fileprivate var gnomeName: String!
  fileprivate var gnome: Gnome?
  
  var delegate: GnomeDetailViewModelDelegate!
  
  init(gnomeName: String, delegate: GnomeDetailViewModelDelegate) {
    super.init()
    self.gnomeName = gnomeName
    self.delegate = delegate
  }
}

// MARK: - Public Methods
extension GnomeDetailViewModel {
  
  func fetchGnomeRelations() {
    guard let gnome = Gnome.fetch(uniqueValue: gnomeName, forKey: "name")! as? Gnome else {
      return
    }
    self.gnome = gnome
    
    delegate.populate(with: gnome)
  }
  
  func gnomeInfo() -> Gnome? {
    return gnome
  }
  
  func title(for section: Int) -> String? {
    
    // converts section value to Section enum
    guard let section = sectionValue(for: section) else {
      return nil
    }
    
    switch section {
    case .profession:
      
      guard let professions = professions() else {
        return nil
      }
      return professions.count > 0 ? "Professions" : nil
      
    case .friend:
      guard let friends = friends() else {
        return nil
      }
      return friends.count > 0 ? "Friends" : nil
    }
  }
  
}

// MARK: - Private Methods
extension GnomeDetailViewModel {
  
  func professions() -> [Profession]? {
    return gnome != nil ? gnome!.professions?.allObjects as? [Profession] : nil
  }
  
  func friends() -> [Gnome]? {
    return gnome != nil ? gnome!.friends?.allObjects as? [Gnome] : nil
  }
  
  /// Converts from section int to TableView.Section enum
  ///
  /// - Parameter section: section to evaluate
  /// - Returns: TableView.Section or nil
  func sectionValue(for section: Int) -> Constants.DetailTableView.Section? {
    guard let section = Constants.DetailTableView.Section(rawValue: section) else {
      return nil
    }
    
    return section
  }
  
  /// Validates if the given section has objects to show
  ///
  /// - Parameter section: section to validate
  /// - Returns: Bool indicating if it has or not
  func hasObjects(inSection section: Int) -> Bool {
    
    guard let section = sectionValue(for: section) else {
      return false
    }
    
    switch section {
    case .profession:
      return professions() != nil ? professions()!.count > 0 : false
      
    case .friend:
      return friends() != nil ? friends()!.count > 0 : false
    }
  }
}

// MARK: - ViewModelTableView Provider
extension GnomeDetailViewModel: ViewModelTableViewProvider {
  typealias Entity = ManagedObjectType
  
  func numberOfSections() -> Int {
    return 2
  }
  
  func numberOfRows(in section: Int) -> Int {
    
    guard let gnome = gnome else {
      return 0
    }
    
    if section == 0 {
      return gnome.professions != nil ? gnome.professions!.count : 0
    }
    
    return gnome.friends != nil ? gnome.friends!.count : 0
  }
  
  func object(atIndexPath indexPath: IndexPath) -> Entity? {
    
    guard let section = Constants.DetailTableView.Section(rawValue: indexPath.section) else {
      return nil
    }
    
    switch section {
    case .profession:
      return professions()?[indexPath.row]
      
    case .friend:
      return friends()?[indexPath.row]
    }
  }
}







