//
//  WeatherViewIntent.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import Foundation

enum WeatherViewEvent: Equatable {
    static func == (lhs: WeatherViewEvent, rhs: WeatherViewEvent) -> Bool {
        switch (lhs, rhs) {
        case (.fetchWeather, .fetchWeather):
            return true
        case (.getCurrrentLocation, .getCurrrentLocation):
            return true
        case let (.loadedWeatherData(lhsData), .loadedWeatherData(rhsData)):
            return lhsData == rhsData
        case let (.loadedCurrentLocation(lhsLocation), .loadedCurrentLocation(rhsLocation)):
            return lhsLocation == rhsLocation
        case (.error, .error):
            return true
        default:
            return false
        }
    }

    case fetchWeather
    case getCurrrentLocation
    case loadedWeatherData(WeatherModel)
    case loadedCurrentLocation(Bool)
    case error(Error)
}
