//
//  ContentView.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 01/10/23.
//

import SwiftUI


struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    switch viewModel.state {
                    case .idle:
                        EmptyView()
                    case .loading:
                        ProgressView("Loading...")
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
            viewModel.send(intent: .getLocation)
        }
    }
}
