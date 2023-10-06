//
//  WeatherEndpointTests.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 05/10/23.
//

import XCTest
@testable import WeatherApp

class WeatherEndpointTests: XCTestCase {

    func testCurrentWeatherEndpoint() {
        let endpoint = WeatherEndpoint.currentWeather(lat: "23", lon: "23")
        let item = URLQueryItem(name: "q", value: "23,23")
        if let queryItems = endpoint.queryItems {
            XCTAssertTrue(queryItems.contains(item))
        } else {
            XCTFail("Doesn't contain query items")
        }

    }
}
