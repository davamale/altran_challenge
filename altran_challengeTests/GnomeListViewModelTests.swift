//
//  GnomeListViewModelTests.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import XCTest


class GnomeListViewModelTests: XCTestCase {
    
    let spyViewController = SpyGnomeListViewController()
    var viewModel: GnomeListViewModel!
    
    override func setUp() {
        super.setUp()
        
      viewModel = GnomeListViewModel(networkManager: NetworkStub()) { action in
        
        switch action.tableViewAction {
        case .finishedLoading:
          return self.spyViewController.promise.fulfill()
        default: break
        }
        
      }
    }
    
    // MARK: - Save List Test
//    func testSaveList() {
//
//        spyViewController.promise = expectation(description: "Calls didFinishLoading delegate method")
//        
//        /*
//         given:
//            A well formed json object
//         */
//        let gnomeList = ObjectHelper.gnomeJsonMock()
//
//        // when:
//        viewModel.saveList(gnomeList: [gnomeList])
//        
//        // then:
//        waitForExpectations(timeout: 1) { (error) in
//            if error != nil {
//                XCTFail(error!.localizedDescription)
//            }
//            
//            XCTAssert(self.viewModel.action.tableViewAction == .finishedLoading, "didFinishLoading wasn't called")
//        }
//    }
  
    // MARK: - Has Fetched Object Test
//    func testHasFetchedObjects() {
//        
//        /*
//         given:
//         fetchedResultsController.fetchedObjects.count greater than zero
//         */
//        let fetchedObjectsGreaterThanZero = ObjectHelper.stubFetchedObjectsGreaterThanZero
//        
//        // when:
//        var hasFetchedObjects = viewModel.hasObjects(in: fetchedObjectsGreaterThanZero)
//        
//        // then
//        XCTAssertTrue(hasFetchedObjects, "Objects fetched are greater than zero")
//        
//        /*
//         given:
//         fetchedResultsController.fetchedObjects nil
//         */
//        let fetchedObjectsEqualToZero = ObjectHelper.stubFetchedObjectsEqualsToZero
//        
//        // when:
//        hasFetchedObjects = viewModel.hasObjects(in: fetchedObjectsEqualToZero)
//        
//        // then
//        XCTAssertFalse(hasFetchedObjects, "Objects are equal to zero")
//        
//        /*
//         given:
//         fetchedResultsController.fetchedObjects.count equals to zero
//         */
//        let fetchedObjectsNil = ObjectHelper.stubFetchedObjectsNil
//        
//        // when:
//        hasFetchedObjects = viewModel.hasObjects(in: fetchedObjectsNil)
//        
//        // then
//        XCTAssertFalse(hasFetchedObjects, "Array object is nil")
//    }
  
    // MARK: - Initial Fetch Test
    func testInitialFetch() {
        
    }
    
//    func testHandleFilterSelection() {
//
//        // given:
//        let noFriendsFilter = Constants.Filter.noFriends
//        
//        // when:
//        let predicate = viewModel.predicate(for: noFriendsFilter)
//        
//        // then:
//        XCTAssert(predicate != nil, "Predicate is not nil")
//        
//        XCTAssert(predicate!.predicateFormat == "hasFriends == 0", "hasFriends must be the proprty to be analyzed")
//        
//        // given:
//        let noProfessionsFilter = Constants.Filter.noProfession
//        
//        // when:
//        let npPredicate = viewModel.predicate(for: noProfessionsFilter)
//        
//        // then:
//        XCTAssert(npPredicate != nil, "Predicate is not nil")
//        
//        XCTAssert(npPredicate!.predicateFormat == "hasProfessions == 0", "hasProfessions must be the proprty to be analyzed")
//        
//        // given:
//        let allFilter = Constants.Filter.all
//        
//        // when:
//        let allPredicate = viewModel.predicate(for: allFilter)
//        
//        // then:
//        XCTAssert(allPredicate == nil, "Predicate is nil to fetch all objects")
//    }
  
}









