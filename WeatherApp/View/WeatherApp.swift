//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 01/10/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject var viewModel = WeatherViewModel(apiService: NetworkService())
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: viewModel)
        }
    }
}
