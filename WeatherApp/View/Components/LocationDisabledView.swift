//
//  LocationDisabledView.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 03/10/23.
//

import SwiftUI

import SwiftUI

struct LocationDisabledView: View {
    var body: some View {
        VStack {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 100))
                .foregroundColor(.red)
                .padding()

            Text("Location Services Disabled")
                .font(.title)
                .fontWeight(.bold)

            Text("To provide you with accurate weather information, please enable location services for this app.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                openSettings()
            }) {
                Text("Open Settings")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func openSettings() {
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
            UIApplication.shared.open(url)
        }
    }
}

