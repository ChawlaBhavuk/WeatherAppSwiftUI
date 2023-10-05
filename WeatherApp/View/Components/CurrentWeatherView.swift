//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import SwiftUI

struct CurrentWeatherView: View {
    let name: String
    let temp: String
    let weatherDesc: String
    let feelTemp: String
    let icon: Image = Image(systemName: "sun.max.fill")

    var body: some View {
        HStack {
            VStack(spacing: 4) {

                Text(name)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                HStack {
                    Image(systemName: "sun.max.fill")
                        .renderingMode(.original)
                        .imageScale(.small)

                    Text("\(temp)º")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                }.font(.system(size: 48))
                    .frame(maxWidth: .infinity)

                Text("\(weatherDesc) - Feels Like \(feelTemp)º")
                    .foregroundColor(.primary)

            }
        }
    }

}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        return CurrentWeatherView(name: "Toronto", temp: "10", weatherDesc: "Sunny", feelTemp: "15")
    }
}

