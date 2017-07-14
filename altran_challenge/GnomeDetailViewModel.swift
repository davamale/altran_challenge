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
    
    func professionsName() -> [String]? {
        return gnome != nil ? gnome!.professions?.allObjects as? [String] : nil
    }
    
    func friends() -> [Gnome]? {
        return gnome != nil ? gnome!.friends?.allObjects as? [Gnome] : nil
    }
    
    func title(for section: Int) -> String {
        return section == 0 ? "Professions" : "Friends"
    }
    
}

// MARK: - Private Methods
fileprivate extension GnomeDetailViewModel {
    
    //TODO: Calculate sections
    
}

// MARK: - ViewModelTableView Provider
extension GnomeDetailViewModel: ViewModelTableViewProvider {
    typealias Entity = Gnome
    
    var datasource: [Gnome]? {
        return gnome != nil ? gnome!.friends?.allObjects as? [Gnome] : nil
    }
    
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
        return datasource != nil ? datasource![indexPath.row] :  nil
    }
}







