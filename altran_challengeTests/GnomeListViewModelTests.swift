//
//  GnomeListViewModelTests.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import XCTest

class SpyGnomeListView: GnomeListViewModelDelegate {
    
    
    
}

class GnomeListViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveList() {
        
        let viewModel = GnomeListViewModel()
//        let promise = expe
        
        /*
         given:
            A well formed json object
         */
        let gnomeList = ObjectHelper.gnomeObjectMock()
        
        // when:
        viewModel.saveList(gnomeList: [gnomeList])
        
        guard let gnomeObject = Gnome.save(object: gnomeList) else {
            return XCTFail("Gnome Object not saved")
        }
        
        // then:
        XCTAssert(gnomeObject.name != nil, "Object not created properly")
        XCTAssert(!gnomeObject.name!.isEmpty, "Object not created properly")
        
        
        /*
         given:
            A Faulty json object
         */
        let faultGnomeList = ObjectHelper.faultGnomeObjectMock()
        
        // when:
        guard let _ = Gnome.save(object: faultGnomeList) else {
            // then:
            XCTAssertTrue(true, "Fault object")
            
            return
        }
        
        
        XCTFail("Fault object, Gnome mustn't be created")
    }
    
}
