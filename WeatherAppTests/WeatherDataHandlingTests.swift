//
//  class WeatherViewModelTests: XCTestCase.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import XCTest
import Combine
@testable import StateMachinePackage
@testable import WeatherApp

class WeatherDataHandlingTests: XCTestCase {
    var viewModel: WeatherDataHandling!
    var apiService: MockAPIService<WeatherModel>!
    var locationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        apiService = MockAPIService()
        locationManager = MockLocationManager()
        viewModel = WeatherDataHandling(apiService: apiService)
        viewModel.locationManager = locationManager
    }

    override func tearDown() {
        viewModel = nil
        apiService = nil
        locationManager = nil
        super.tearDown()
    }

    // Test initialization of WeatherViewModel
    func testInit() {
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.state, .idle)
    }


    func testFetchCurrentLocationWhenLocationEnabled() async {
        locationManager.locationEnabled = true
        let currentState = viewModel.fetchCurrentLocation()
        let currentStateEvent = await currentState.execute()
        XCTAssertEqual(currentStateEvent, .loadedCurrentLocation(true))
    }

    func testFetchCurrentLocationWhenLocationEnabledWithContinuation() async {
        locationManager.isLocationEnabledSubject.send(true)
        let locationEnabled =  await viewModel.checkLocationEnabledOrNot()
        XCTAssertTrue(locationEnabled)
    }

    func testFetchCurrentLocationWhenLocationDisabled() async {
        locationManager.locationEnabled = false
        let currentState = viewModel.fetchCurrentLocation()
        let currentStateEvent = await currentState.execute()
        XCTAssertEqual(currentStateEvent, .loadedCurrentLocation(false))
    }

    func testFetchWeatherData() async {
        let currentState = viewModel.fetchWeatherData()
        let currentStateEvent = await currentState.execute()
        XCTAssertEqual(currentStateEvent, .loadedWeatherData(apiService.mockWeatherData()))
    }

    func testFetchWeatherDataWithContinuation() async {
        do {
            let modelData = try await viewModel.fetchWeatherDatacheckedContinuation()
            XCTAssertEqual(modelData, apiService.mockWeatherData())
        } catch {
            XCTFail("Fail test case")
        }
    }

    func testFetchWeatherDataWithContinuationError() async {
        do {
            apiService.isError = true
            let modelData = try await viewModel.fetchWeatherDatacheckedContinuation()
            XCTAssertNil(modelData)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testFetchWeatherDataWithError() async {
        let currentState = viewModel.fetchWeatherData()
        apiService.isError = true
        let currentStateEvent = await currentState.execute()
        XCTAssertEqual(currentStateEvent, .error(NetworkError.responseError))
    }


}
