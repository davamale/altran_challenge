//
//  GnomeDetailViewModelTests.swift
//  altran_challenge
//
//  Created by Dava on 7/14/17.
//
//

import XCTest

class GnomeDetailViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSectionValue() {
        
        let spyViewController = SpyGnomeDetailViewController()
        let viewModel = GnomeDetailViewModel(gnomeName: "david", delegate: spyViewController)
        
        // given:
        var section = 0
        
        // when:
        var sectionValue = viewModel.sectionValue(for: section)
        
        // then:
        XCTAssert(sectionValue == Constants.DetailTableView.Section.profession, "Section converts to profession enum")
        
        // given:
        section = 1
        
        // when:
        sectionValue = viewModel.sectionValue(for: section)
        
        // then:
        XCTAssert(sectionValue == Constants.DetailTableView.Section.friend, "Section converts to friend enum")
        
        // given:
        section = 2
        
        // when:
        sectionValue = viewModel.sectionValue(for: section)
        
        // then:
        XCTAssert(sectionValue == nil, "Section for a number greater than 1 does not exist in enum")
    }
    
}
