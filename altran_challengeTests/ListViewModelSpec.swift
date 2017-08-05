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
      
      let networkStub = NetworkStub()
      let viewModel = GnomeListViewModel(networkManager: networkStub) { action in
        
        switch action.tableViewAction {
        case .finishedLoading:
          break
        default: break
        }
        
      }
      
      context("Get Gnome list with successful return from end-point") {
        viewModel.handleGetList()
        
        it("TableviewAction property in action should be updated to .finishedLoading") {
          expect(viewModel.action.tableViewAction)
            .toEventually(equal(TableViewAction.finishedLoading))
        }
      }
      
      context("Get Gnome list with corrupted response") {
        networkStub.shouldReturnSuccess = false
        viewModel.handleGetList()
        
        it("Show message property should be called") {
          expect(viewModel.action.alertMessage)
            .toEventuallyNot(beNil())
        }
      }
      
      // TODO: test filter
      
    }
  }
}












