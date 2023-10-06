//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 02/10/23.
//

import Foundation
import Combine
import StateMachinePackage

class WeatherDataHandling: ObservableObject {

    @Published private(set) var state: WeatherViewState = .idle
    private let apiService: APIService
    @Published var locationManager = LocationManager()

    init(apiService: APIService) {
        self.apiService = apiService
    }

    private var cancellables = Set<AnyCancellable>()

    func fetchCurrentLocation() -> SideEffect<WeatherViewEvent> {
        return SideEffect {
            if let locationEnabled = self.locationManager.locationEnabled  {
                return .loadedCurrentLocation(locationEnabled)
            }

            return .loadedCurrentLocation(await self.checkLocationEnabledOrNot())
        }

    }

    func checkLocationEnabledOrNot() async -> Bool {
        return  await withCheckedContinuation { continuation in
            self.locationManager.isLocationEnabledSubject
                .sink { isEnabled in
                    continuation.resume(returning: isEnabled)
                }
                .store(in: &cancellables)
        }

    }

    func fetchWeatherData() -> SideEffect<WeatherViewEvent> {
        return SideEffect { [weak self] in
            do {
                if let data = try await self?.fetchWeatherDatacheckedContinuation() {
                    return .loadedWeatherData(data)
                } else {
                    return .error(NetworkError.unknown)
                }
            } catch {
                return .error(error)
            }
        }
    }

    func fetchWeatherDatacheckedContinuation()  async throws -> WeatherModel {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                self.apiService.request(type: WeatherModel.self, WeatherEndpoint.currentWeather(
                    lat: String(format: "%f", self.locationManager.latitude),
                    lon: String(format: "%f", self.locationManager.longitude)
                ))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):

                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { data in
                    continuation.resume(returning: data)
                })
                .store(in: &self.cancellables)
            }
        }
        catch {
            throw(error)
        }
    }
}
