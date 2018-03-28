//
//  ScubaTests.swift
//  ScubaTests
//
//  Created by Hubert Ka on 2018-01-06.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import XCTest
@testable import Scuba

class ScubaTests: XCTestCase {
    
    //MARK: Dive Class Tests
    
    // Confirm that the Dive initializer returns a Dive object when passed valid parameters.
    func testDiveInitializationSucceeds() {
        // Dive number is not empty.
        let notEmpty = Dive.init(diveNumber: "1", activity: "notEmpty", date: "1/1/1", location: "Empty", photo: nil)
        XCTAssertNotNil(notEmpty)
    }
    
    // Confirm that the Dive initializer returns nil when passed a less than 1 dive number or any empty string properties.
    func testMealInitializationFails() {
        // Dive number is empty.
        let emptyDiveNumber = Dive.init(diveNumber: "", activity: "", date: "", location: "", photo: nil)
        XCTAssertNil(emptyDiveNumber)
    }
    
}
