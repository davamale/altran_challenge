//
//  CellProtocolTests.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import XCTest

class CellProtocolTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIdentifier() {

        // given
        let classNameString = "MockTableViewCell"
        let identifier = "Identifier"
        
        // when
        let calculatedIdentifier = MockTableViewCell.identifier
        
        // then
        XCTAssert(calculatedIdentifier == "\(classNameString)\(identifier)")
    }
    
    func testClassName() {
        // given
        let classNameString = "MockTableViewCell"
        
        // when
        let calculatedClassName = MockTableViewCell.className
        
        // then
        XCTAssert(calculatedClassName == classNameString)
    }
    
}




