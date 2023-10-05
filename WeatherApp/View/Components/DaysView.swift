//
//  DaysView.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 04/10/23.
//

import SwiftUI

struct DaysView: View {
    let day: String
    let highTemp: String
    let lowTemp: String
    let icon: Image = Image(systemName: "sun.max.fill")

    var body: some View {
        HStack {
            Text(day)
                .fontWeight(.medium)
            Spacer()
            Text("\(highTemp)º / \(lowTemp)º")
                .fontWeight(.light)
            icon
                .renderingMode(.original)
                .imageScale(.large)
        }
        .padding(.horizontal)
        .padding(.vertical, 22)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10)
    }
}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        return DaysView(day: "Tuesday", highTemp: "29", lowTemp: "16")
    }
}
