//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Bhavuk Chawla on 03/10/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    var isLocationEnabledSubject = CurrentValueSubject<Bool, Never>(false)

    var isLocationEnabled: Bool {
        get { isLocationEnabledSubject.value }
        set { isLocationEnabledSubject.send(newValue) }
    }

    private var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.isLocationEnabled = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            isLocationEnabled = false
        }
    }


}
