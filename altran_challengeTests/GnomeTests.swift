//
//  GnomeTests.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import XCTest

class GnomeTests: XCTestCase {
    
    var gnomeList: JSON?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        gnomeList = nil
    }
    
    //FIXME: Create a Gnome.save stub
//    func testSave() {
//        /*
//         given:
//         A malformed json object
//         */
//        gnomeList = ObjectHelper.noNameGnomeJsonMock()
//        
//        // when:
//        var gnomeObject = Gnome.save(object: gnomeList)
//        
//        XCTAssert(gnomeObject == nil, "Can't create Gnome object without a name")
//        
//        /*
//         given:
//         An only name json object
//         */
//        let onlyGnomeList = ObjectHelper.onlyNameGnomeJsonMock()
//        
//        // when:
//        gnomeObject = Gnome.save(object: onlyGnomeList)
//        
//        XCTAssert(gnomeObject != nil)
//        XCTAssert(gnomeObject?.name != nil, "Name is the minimum required to create a Gnome object")
//    }
    
}
