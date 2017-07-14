//
//  SpyGnomeListViewController.swift
//  altran_challenge
//
//  Created by Dava on 7/10/17.
//
//

import Foundation
import XCTest

class SpyGnomeListViewController: GnomeListViewModelDelegate {

    var promise: XCTestExpectation!
    var finishLoading: Bool!
    
    
    func didFinishLoading() {
        finishLoading = true
        promise.fulfill()
    }
    
    func showEmtpyListView() {}
    
    func shouldReloadTableView() {}
    
    func beginUpdates() {}
    
    func endUpdates() {}
    
    func didInsert(newObject:Gnome, at newIndexPath: IndexPath) {}
    
    func didUpdate(object:Gnome, at indexPath: IndexPath) {}
    
    func showError(withMessage message: String) {}

}
