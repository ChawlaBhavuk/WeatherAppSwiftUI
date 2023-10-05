//
//  WeatherViewReducer.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import Foundation
import StateMachinePackage

struct WeatherViewReducer {
    static func reduce(state: WeatherViewState, intent: WeatherViewIntent, weatherData: WeatherModel?, error: Error?) -> WeatherViewState {
        switch intent {
        case .fetchWeather:
            if let error = error {
                return .error(error)
            } else if let weatherData = weatherData {
                return .loaded(weatherData)
            } else {
                return .loading
            }
        case .getLocation:
            return state // No state change for getLocation intent
        }
    }
}
