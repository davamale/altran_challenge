//
//  GnomeListViewModelTests.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import XCTest

class GnomeListViewModelTests: XCTestCase {
    
    let spyViewController = SpyGnomeListView()
    var viewModel: GnomeListViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = GnomeListViewModel(delegate: spyViewController)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Save List Test
    func testSaveList() {

        spyViewController.promise = expectation(description: "Calls didFinishLoading delegate method")
        
        /*
         given:
            A well formed json object
         */
        let gnomeList = ObjectHelper.gnomeJsonMock()

        // when:
        viewModel.saveList(gnomeList: [gnomeList])
        
        // then:
        waitForExpectations(timeout: 1) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
            
            XCTAssert(self.spyViewController.finishLoading == true, "didFinishLoading wasn't called")
        }
    }
    
    // MARK: - Has Fetched Object Test
    func testHasFetchedObjects() {
        
        /*
         given:
         fetchedResultsController.fetchedObjects.count greater than zero
         */
        let fetchedObjectsGreaterThanZero = ObjectHelper.stubFetchedObjectsGreaterThanZero
        
        // when:
        var hasFetchedObjects = viewModel.hasFetchedObjects(in: fetchedObjectsGreaterThanZero)
        
        // then
        XCTAssertTrue(hasFetchedObjects, "Objects fetched are greater than zero")
        
        /*
         given:
         fetchedResultsController.fetchedObjects nil
         */
        let fetchedObjectsEqualToZero = ObjectHelper.stubFetchedObjectsEqualsToZero
        
        // when:
        hasFetchedObjects = viewModel.hasFetchedObjects(in: fetchedObjectsEqualToZero)
        
        // then
        XCTAssertFalse(hasFetchedObjects, "Objects are equal to zero")
        
        /*
         given:
         fetchedResultsController.fetchedObjects.count equals to zero
         */
        let fetchedObjectsNil = ObjectHelper.stubFetchedObjectsNil
        
        // when:
        hasFetchedObjects = viewModel.hasFetchedObjects(in: fetchedObjectsNil)
        
        // then
        XCTAssertFalse(hasFetchedObjects, "Array object is nil")
    }
    
    // MARK: - Initial Fetch Test
    func testInitialFetch() {
        
    }
    
    // MARK: - Object at Index Test
//    func testGnomeAtIndexPath() {
//        
//        // given:
//        let gnomeArray = [ObjectHelper.gnomeJsonMock(name: "William Anderson"), ObjectHelper.gnomeJsonMock()]
//        let indexPath = IndexPath(item: 1, section: 0)
//        
//        // when:
//        let calculatedObject = viewModel.object(atIndexPath:indexPath)
//        
//        XCTAssert(gnomeArray[indexPath.row] == calculatedObject)
//    }
    
}









