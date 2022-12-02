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
    private(set) var currentLocation: CLLocationCoordinate2D?
    private(set) var defualtLocation: CLLocationCoordinate2D?
    private override init() {}
    func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0].coordinate
        self.currentLocation = location
        NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.main), object: location)
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
            guard let location = manager.location else { return }
            let model = RealmManager.shared.read(RealmDataModel.self)[0]
            RealmManager.shared.update(model) { updateModel in
                updateModel.lat = location.coordinate.latitude
                updateModel.lon = location.coordinate.longitude
                updateModel.loadMain = true
            }
        
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location Auth: denied")
        default:
            break
        }
    }
}
