//
//  ContentView.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 01/10/23.
//

import SwiftUI
import StateMachinePackage

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherDataHandling
    @ObservedObject var stateMachine: ViewStateMachine<WeatherViewState, WeatherViewEvent>
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    switch stateMachine.state {
                    case .idle:
                        EmptyView()
                        let _ = stateMachine.send(.getCurrrentLocation)
                    case .loading:
                        ProgressView("Loading...")
                        let _ = stateMachine.send(.fetchWeather)
                    case .loaded(let weatherData):
                        WeatherDetailView(weatherData: weatherData)
                    case .error(let error):
                        Text("Error: \(error.localizedDescription)")
                    case .disabled:
                        LocationDisabledView()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await self.stateMachine.start()
            }
        }
    }
}

