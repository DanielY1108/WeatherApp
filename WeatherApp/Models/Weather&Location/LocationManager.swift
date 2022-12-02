//
//  LocationManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationServiceDelegate {
    func updateLocation()
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    private(set) var location: CLLocationCoordinate2D?
    private(set) var defualtLocation: CLLocationCoordinate2D?
    private override init() {
        super.init()
        self.setupDefualtLocation()
    }
    func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    private func setupDefualtLocation() {
        defualtLocation = CLLocationCoordinate2D(latitude: -33.865143, longitude: 151.209900)
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0].coordinate
        self.location = location
        RealmManager.shared.writeLocation(location, cityName: "Current Location", mainLoad: true)
        WeatherManager.shared.getEachWeatherData(lat: location.latitude, lon: location.longitude, weatherVC: .listViewController) {
            NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.main), object: nil)
        }
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
            setupDefualtLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: authorizedWhenInUse")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location Auth: denied")
            setupDefualtLocation()
        default:
            break
        }
    }
}
