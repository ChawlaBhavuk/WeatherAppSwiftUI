//
//  HelpersTests.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 05/10/23.
//

import XCTest
@testable import WeatherApp

class HelpersTests: XCTestCase {

    func testDayOfWeekConversion() {

        let testDateString = "2023-10-05"
        let expectedDayOfWeek = "Thursday"
        let result = Helpers.dayOfWeek(from: testDateString)
        XCTAssertEqual(result, expectedDayOfWeek)
    }

    func testInvalidDateConversion() {
        let invalidDateString = "InvalidDate"
        let result = Helpers.dayOfWeek(from: invalidDateString)
        XCTAssertNil(result)
    }
}
