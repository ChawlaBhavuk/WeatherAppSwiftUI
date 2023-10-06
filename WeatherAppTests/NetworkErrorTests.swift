//
//  NetworkErrorTests.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 05/10/23.
//

import XCTest
@testable import WeatherApp


class NetworkErrorTests: XCTestCase {

    func testInvalidURLErrorDescription() {
        let error = NetworkError.invalidURL
        let description = error.errorDescription
        XCTAssertEqual(description, "Invalid URL")
    }

    func testResponseErrorDescription() {
        let error = NetworkError.responseError
        let description = error.errorDescription
        XCTAssertEqual(description, "Unexpected status code")
    }

    func testUnknownErrorDescription() {
        let error = NetworkError.unknown
        let description = error.errorDescription
        XCTAssertEqual(description, "Unknown error")
    }
}
