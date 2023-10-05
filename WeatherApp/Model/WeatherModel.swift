//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 02/10/23.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable, Equatable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable, Equatable  {
    static func == (lhs: DataClass, rhs: DataClass) -> Bool {
        return lhs.nearestArea == rhs.nearestArea &&
        lhs.currentCondition == rhs.currentCondition &&
        lhs.weather == rhs.weather
    }

    let nearestArea: [NearestArea]
    let currentCondition: [CurrentCondition]
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case nearestArea = "nearest_area"
        case currentCondition = "current_condition"
        case weather
    }
}


// MARK: - CurrentCondition
struct CurrentCondition: Codable, Equatable  {
    let tempC: String
    let weatherDesc: [WeatherDesc]
    let feelsLikeC: String

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_C"
        case weatherDesc
        case feelsLikeC = "FeelsLikeC"
    }
}

// MARK: - WeatherDesc
struct WeatherDesc: Codable, Equatable  {
    let value: String
}

// MARK: - NearestArea
struct NearestArea: Codable, Equatable  {
    let areaName: [WeatherDesc]
    let latitude, longitude: String
}

// MARK: - Request
struct Request: Codable, Equatable  {
    let type, query: String
}

// MARK: - Weather
struct Weather: Codable, Equatable {
    let date: String
    let maxtempC, mintempC: String

    var day: String {
        Helpers.dayOfWeek(from: date) ?? ""
    }
}

extension Weather: Identifiable {
  var id: UUID { return UUID() }
}

enum Helpers {
    static func dayOfWeek(from value: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: value) else { return nil }

        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
    }
}
