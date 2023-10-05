//
//  class WeatherViewModelTests: XCTestCase.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import XCTest
import Combine
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var apiService: MockAPIService<WeatherModel>!
    var locationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        apiService = MockAPIService()
        locationManager = MockLocationManager()
        viewModel = WeatherViewModel(apiService: apiService)
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

    // Test fetching weather data when location is enabled
    func testFetchWeatherDataWithLocationEnabled() {
        let expectation = XCTestExpectation(description: "Weather data fetched successfully")
        locationManager.isLocationEnabledSubject.send(true)

        DispatchQueue.global().async {
            self.viewModel.send(intent: .fetchWeather)
            sleep(2)
            expectation.fulfill()
        }

        let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
        if result == .completed {
            print(self.viewModel.state)
            XCTAssertEqual(viewModel.state, .loaded(apiService.mockWeatherData()))
        } else {
            XCTFail("Timeout occurred while waiting for the expectation")
        }
    }
    
    // Test handling disabled location
    func testFetchWeatherDataWithLocationDisabled() {
        locationManager.isLocationEnabledSubject.send(false)
        viewModel.send(intent: .getLocation)
        XCTAssertEqual(viewModel.state, .disabled)
    }

    // Test handling API failure
    func testFetchWeatherDataFailure() {
        let expectation = XCTestExpectation(description: "Weather data fetched with erroor")
        apiService.isError = true
        locationManager.isLocationEnabledSubject.send(true)
        DispatchQueue.global().async {
            self.viewModel.send(intent: .fetchWeather)
            sleep(2)
            expectation.fulfill()
        }

        let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
        if result == .completed {
            XCTAssertEqual(self.viewModel.state, .error(NetworkError.responseError))
        } else {
            XCTFail("Timeout occurred while waiting for the expectation")
        }
    }
}

//// Create a mock API service for testing
class MockAPIService<T>: APIService where T: Decodable {
    var isError = false
    func request<T>(type: T.Type, _ endpoint: Endpoint) -> Future<T, Error> where T : Decodable {
        return Future<T, Error>  { [weak self] promise in

            guard let self = self, !self.isError else {
                promise(.failure(NetworkError.responseError))
                return
            }

            let mockData = self.mockWeatherData() as! T
            promise(.success(mockData))
        }
    }

    func mockWeatherData() -> WeatherModel {
        WeatherModel(data: DataClass(nearestArea: [NearestArea(areaName: [WeatherDesc(value: "Toronto")], latitude: "12.5", longitude: "10.5")], currentCondition: [CurrentCondition(tempC: "10", weatherDesc: [WeatherDesc(value: "Sunny")], feelsLikeC: "12")], weather: [Weather(date: "12/10/2023", maxtempC: "12", mintempC: "10")]))
    }

}

//// Create a mock LocationManager for testing
class MockLocationManager: LocationManager {

    var isLocationEnabledPublisher: AnyPublisher<Bool, Never> {
        return isLocationEnabledSubjects.eraseToAnyPublisher()
    }


    var isLocationEnabledSubjects = PassthroughSubject<Bool, Never>()

}
