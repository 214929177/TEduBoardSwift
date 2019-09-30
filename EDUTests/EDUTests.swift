//
//  EDUTests.swift
//  EDUTests
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//
import XCTest

@testable import EDU

class EDUTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// 测试ClassRoom
    func testClassRoom() {
        XCTAssert(ClassRoom.isValidateClassId("123"))
        XCTAssert(!ClassRoom.isValidateClassId(""))
        XCTAssert(!ClassRoom.isValidateClassId("as"))
        XCTAssert(!ClassRoom.isValidateClassId(nil))
    }

}
