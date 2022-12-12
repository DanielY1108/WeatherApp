//
//  LocationManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import UIKit
import MapKit
import CoreLocation

enum LocationError: Error {
    case coordinateError
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    private(set) var currentLocation: CLLocationCoordinate2D?
    private(set) var defualtLocation: CLLocationCoordinate2D?
    private override init() {}
    func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    func getLocationName(lat: Double, lon: Double) async throws -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        let placemark = try await geoCoder.reverseGeocodeLocation(location)
        guard let cityName = placemark[0].locality else { throw LocationError.coordinateError }
        return cityName
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0].coordinate
        self.currentLocation = location
        NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.main), object: location)
        let model = RealmManager.shared.read(RealmDataModel.self)[0]
        RealmManager.shared.checkLoadMainView(display: model)
        RealmManager.shared.update(model) { updateModel in
            updateModel.lat = location.latitude
            updateModel.lon = location.longitude
            updateModel.loadMain = true
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
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: authorizedWhenInUse")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location Auth: denied")
        default:
            break
        }
    }
}
