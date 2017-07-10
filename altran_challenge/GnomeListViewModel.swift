//
//  DashboardViewModel.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import Foundation

protocol GnomeListViewModelDelegate: class {
    
}

class GnomeListViewModel {
    
    // MARK: - Public Methods
    func saveList(gnomeList: JSONArray) {
        
        for gnome in gnomeList {
            if let gnomeObject = Gnome.save(object: gnome) {
                print(gnomeObject)
            }
        }
    }
    
    // MARK: - Private Methods
    private func getList(completion: (JSONArray?) -> Void) {
        NetworkManager.get(url: URL(string: Constants.Routes.gnomeInfo)!) { (json, error) in
            
            guard let gnomeList = json else {
                return
            }
            
            self.saveList(gnomeList: gnomeList)
            
        }
    }
}
