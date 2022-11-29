//
//  LocationManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import UIKit
import MapKit
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    private(set) var location: Locations?
    private override init() {
        super.init()
        self.saveCurrnetLocation()
    }
    private func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    private func saveCurrnetLocation() {
        guard let location = manager.location else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let currrentLocation = Locations(latitude: lat, longitude: lon)
        self.location = currrentLocation
    }
    func checkLocationService() {
        setupLocationManager()
        locationManagerDidChangeAuthorization(manager)
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location Auth: notDetermined")
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: authorizedWhenInUse")
            manager.startUpdatingLocation()
            saveCurrnetLocation()
        case .denied, .restricted:
            print("Location Auth: denied")
        default:
            break
        }
    }
}
