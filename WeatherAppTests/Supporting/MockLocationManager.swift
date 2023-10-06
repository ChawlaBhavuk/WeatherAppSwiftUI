//
//  MockLocationManager.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 05/10/23.
//

import Foundation
import Combine
@testable import WeatherApp

//// Create a mock LocationManager for testing
class MockLocationManager: LocationManager {

    var isLocationEnabledPublisher: AnyPublisher<Bool, Never> {
        return isLocationEnabledSubjects.eraseToAnyPublisher()
    }
    var isLocationEnabledSubjects = PassthroughSubject<Bool, Never>()

}
