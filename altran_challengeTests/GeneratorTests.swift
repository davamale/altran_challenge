//
//  GeneratorTests.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import XCTest

class String_IdGenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testId() {
        
        /*
         given:
            new generated id
         */
        let id_1 = Generator.newId
        
        // when:
        let id_2 = Generator.newId
        
        // then:
        assert(id_1 != id_2, "id's must be unique")
        
    }
    
}
