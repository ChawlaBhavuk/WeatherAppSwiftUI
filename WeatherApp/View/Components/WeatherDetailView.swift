//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 03/10/23.
//

import SwiftUI
import Combine

struct WeatherDetailView: View {

    var weatherData: WeatherModel?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let weatherData = weatherData?.data {
                    CurrentWeatherView(
                        name: weatherData.nearestArea.first?.areaName.first?.value ?? "",
                        temp: weatherData.currentCondition.first?.tempC ?? "",
                        weatherDesc: weatherData.currentCondition.first?.weatherDesc.first?.value ?? "",
                        feelTemp: weatherData.currentCondition.first?.feelsLikeC ?? ""
                    )
                }
                if let weather = weatherData?.data.weather {
                    ForEach(weather) { weather in
                        DaysView(day: weather.day, highTemp: weather.maxtempC, lowTemp: weather.mintempC)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

