//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 01/10/23.
//

import SwiftUI
import StateMachinePackage

@main
struct WeatherApp: App {
    @StateObject var viewModel = WeatherDataHandling(apiService: NetworkService())
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: viewModel, stateMachine: makeViewStateMachine(initialState: .idle, viewModel: viewModel))
        }
    }

    func makeViewStateMachine(initialState: WeatherViewState, viewModel: WeatherDataHandling) -> ViewStateMachine<WeatherViewState, WeatherViewEvent> {
        let weatherStateMachine = viewModel.makeWeatherStateMachine(initialState: initialState)

      return ViewStateMachine(stateMachine: weatherStateMachine)
    }
}



