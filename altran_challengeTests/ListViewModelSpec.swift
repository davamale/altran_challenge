//
//  ListViewModelSpec.swift
//  altran_challenge
//
//  Created by Dava on 8/4/17.
//
//

import UIKit
import Quick
import Nimble

class ListViewModelSpec: QuickSpec {

  override func spec() {
    
    describe("ListViewModelSpec") {
      
      let viewModel = GnomeListViewModel() { action in
        
        switch action.tableViewAction {
        case .finishedLoading:
          break
        default: break
        }
        
      }
      
      context("After inserting objects") {
        let fetchedObjectsGreaterThanZero = ObjectHelper.stubFetchedObjectsGreaterThanZero
        let hasFetchedObjects = viewModel.hasObjects(in: fetchedObjectsGreaterThanZero)
        
        it("Has objects method should return true") {
          expect(hasFetchedObjects).to(beTrue())
        }
      } // ends After inserting objects
      
      
      context("Save list with valid objects") {
        let spyViewController = SpyGnomeListViewController()
        spyViewController.promise = expectation(description: "Calls didFinishLoading delegate method")
        
        let gnomeList = ObjectHelper.gnomeJsonMock()
        viewModel.saveList(gnomeList: [gnomeList])
        
        it("TableviewAction property in action should be updated to .finishedLoading") {
          expect(viewModel.action.tableViewAction).toEventually(equal(TableViewAction.finishedLoading))
        }
        
      }
      
    }
    
  }
}
