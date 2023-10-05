//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 02/10/23.
//

import Foundation
import Combine


class WeatherViewModel: ObservableObject {

    @Published private(set) var state: WeatherViewState = .idle
    private let apiService: APIService
    @Published var locationManager = LocationManager()


    init(apiService: APIService) {
        self.apiService = apiService
    }

    func send(intent: WeatherViewIntent) {
        switch intent {
        case .fetchWeather:
            fetchWeatherData()
        case .getLocation:
            fetchCurrentLocation()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    func fetchCurrentLocation() {

        locationManager.isLocationEnabledSubject
            .sink { isEnabled in
                if isEnabled {
                    self.send(intent: .fetchWeather)
                } else {
                    self.state = .disabled
                }
            }
            .store(in: &cancellables)


    }

    private func fetchWeatherData() {
        // Transition to the loading state
        state = .loading

        apiService.request(type: WeatherModel.self, WeatherEndpoint.currentWeather(
            lat: String(format: "%f", locationManager.latitude),
            lon: String(format: "%f", locationManager.longitude)
        ))
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.state = WeatherViewReducer.reduce(state: self.state, intent: .fetchWeather, weatherData: nil, error: error)
            }
        }, receiveValue: { data in
            self.state = WeatherViewReducer.reduce(state: self.state, intent: .fetchWeather, weatherData: data, error: nil)
        })
        .store(in: &self.cancellables)
    }

}
