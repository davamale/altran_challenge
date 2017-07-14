//
//  ColorTests.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import XCTest

class ColorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHairColor() {
        
        // given:
        let color = "Red"
        
        // when:
        let hairColor = Constants.HairColor(rawValue: color)!
        
        // then:
        XCTAssert(color.hairColor() == hairColor.color(), "UIColor matches the hair color string")
    }
    
}
