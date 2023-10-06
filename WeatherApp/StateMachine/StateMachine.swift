//
//  StateMachine.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 05/10/23.
//

import StateMachinePackage

extension WeatherDataHandling {
    func makeWeatherStateMachine(initialState: WeatherViewState) -> StateMachine<WeatherViewState, WeatherViewEvent> {

        StateMachine(initial: initialState) { state, event in
            switch( state, event) {
            case (.idle, .getCurrrentLocation):
                return .newState(.loading, output: self.fetchCurrentLocation())
            case (.loading, .loadedCurrentLocation(let value)):
                return value ? .sameState(output: self.fetchWeatherData()) : .newState(.disabled)
            case (.loading, .loadedWeatherData(let data)):
                return .newState(.loaded(data))
            case (.loading, .error(let error)):
                return .newState(.error(error))
            default:
                return .sameState()
            }
        }
    }

}
