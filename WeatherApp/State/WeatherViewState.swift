//
//  WeatherViewState.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import Foundation

enum WeatherViewState: Equatable {
    static func == (lhs: WeatherViewState, rhs: WeatherViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case let (.loaded(lhsWeather), .loaded(rhsWeather)):
            return lhsWeather == rhsWeather
        case (.disabled, .disabled):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }

    case idle
    case loading
    case loaded(WeatherModel)
    case disabled
    case error(Error)
}
