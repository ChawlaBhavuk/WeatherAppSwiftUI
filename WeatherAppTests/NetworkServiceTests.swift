//
//  NetworkServiceTests.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import XCTest
import Combine
@testable import WeatherApp

class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        let url = URL(string: "https://test.com")!
        networkService = NetworkService(baseURL: url, session: urlSession)
    }

    func testSuccessfulRequest() {
        let mockData = MockAPIService<WeatherModel>().mockWeatherData()
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(mockData)

        // Set up the MockURLProtocol to handle requests
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonData!)
        }

        let endpoint = WeatherEndpoint.currentWeather(lat: "23", lon: "23")
        let expectation = XCTestExpectation(description: "Successful request")

        self.networkService.request(type: WeatherModel.self, endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                }
            }, receiveValue: { data in
                XCTAssertNotNil(data)
                XCTAssertEqual(data.data.nearestArea.first?.areaName.first?.value, "Toronto")
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        wait(for: [expectation], timeout: 2.0)
    }

    func testNetworkError() {
        MockURLProtocol.requestHandler = { request in
            let error = NetworkError.responseError
            throw error
        }

        let endpoint = WeatherEndpoint.currentWeather(lat: "23", lon: "23")
        let expectation = XCTestExpectation(description: "Network error")

        self.networkService.request(type: WeatherModel.self, endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error, NetworkError.responseError)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Received unexpected data for a network error")
            })
            .store(in: &self.cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

}


