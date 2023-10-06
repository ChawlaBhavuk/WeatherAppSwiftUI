//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 02/10/23.
//

import Foundation

enum WeatherEndpoint {

    static func currentWeather(lat: String, lon: String) -> Endpoint {
        let path = "/premium/v1/weather.ashx"  ///data/2.5/weather"
        let queryItems = [
            URLQueryItem(name: "q", value: "\(lat),\(lon)"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "key", value: AppConstants.appKey),
            URLQueryItem(name: "num_of_days", value: "10"),
            URLQueryItem(name: "forcast", value: "yes"),
            URLQueryItem(name: "cc", value: "yes"),
            URLQueryItem(name: "includelocation", value: "yes"),
            
        ]
        return Endpoint(path: path, method: .get, queryItems: queryItems, body: nil, headers: nil)
    }
}
