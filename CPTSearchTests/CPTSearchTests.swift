//
//  CPTSearchTests.swift
//  CPTSearchTests
//
//  Created by Jonathan on 11/20/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import XCTest
@testable import CPTSearch

class CPTSearchTests: XCTestCase {

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
    
    //MARK: CPT Class Tests
    
    // Confirm that Specialist initializer returns the specialist object when passed through the parameters
    func testSpecialistInitializationSucceeds() {
        
        // All parameters filled
        let parametersfilled = Specialists.init(firstname: "Truc", lastname: "Herman", department: "Radiology", email: "TrucHerman@jcu.edu", phonenumber: "216-888-8888")
        XCTAssertNotNil(parametersfilled)
    }
    
    // Confirm the Specialist initializer returns nil when empty or missing a parameter
    func testSpecialistInitializationFails() {
        
        // All parameters empty
        let parametersempty = Specialists.init(firstname: "", lastname: "", department: "", email: "", phonenumber: "")
        XCTAssertNil(parametersempty)
        
        // One parameter is empty
        let parametersmissing = Specialists.init(firstname: "Truc", lastname: "", department: "Radiology", email: "TrucHerman@jcu.edu", phonenumber: "216-888-8888")
        XCTAssertNil(parametersmissing)
        
        // Multiple missing parameters
        let parametersmissingM = Specialists.init(firstname: "Truc", lastname: "", department: "Radiology", email: "", phonenumber: "216-888-8888")
        XCTAssertNil(parametersmissingM)
    }

}
