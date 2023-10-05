//
//  NetworkServiceTests.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import XCTest
import Combine
@testable import WeatherApp


//class ProfileTests: XCTestCase {
//    // custom urlsession for mock network calls
//    var urlSession: URLSession!
//
//    override func setUpWithError() throws {
//        // Set url session for mock networking
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [MockURLProtocol.self]
//        urlSession = URLSession(configuration: configuration)
//    }
//
//    func testGetProfile() throws {
//        // Profile API. Injected with custom url session for mocking
//        let profileAPI = ProfileAPI(urlSession: urlSession)
//
//        // Set mock data
//        let sampleProfileData = UserProfile(name: "Yugantar")
//        let mockData = try JSONEncoder().encode(sampleProfileData)
//
//        // Return data in mock request handler
//        MockURLProtocol.requestHandler = { request in
//            return (HTTPURLResponse(), mockData)
//        }
//
//        // Set expectation. Used to test async code.
//        let expectation = XCTestExpectation(description: "response")
//
//        // Make mock network request to get profile
//        profileAPI.getProfile { user in
//            // Test
//            XCTAssertEqual(user.name, "Yugantar")
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 1)
//    }
//}


class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
    }
}

