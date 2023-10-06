//
//  MockLocationManager.swift
//  WeatherAppTests
//
//  Created by Bhavuk Chawla on 05/10/23.
//

import Foundation
import Combine
@testable import WeatherApp


//// Create a mock API service for testing
class MockAPIService<T>: APIService where T: Decodable {
    var isError = false
    func request<T>(type: T.Type, _ endpoint: Endpoint) -> Future<T, NetworkError> where T : Decodable {
        return Future<T, NetworkError>  { [weak self] promise in

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
