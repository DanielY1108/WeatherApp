//
//  LocationManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject{
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
}
// MARK: - Location Delegate

extension LocationManager: CLLocationManagerDelegate {
    func setupLocation(completion: () -> Void) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        completion()
    }
    
    private func setupCoordinate() {
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        print(lat, lon)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        if let location = locations.first {
            currentLocation = location
            setupCoordinate()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            debugPrint("Location Auth: Allow")
        case .notDetermined , .denied , .restricted:
            debugPrint("Location Auth: denied")
        default:
            break
        }
    }
}



//
//import UIKit
//import CoreLocation
//extension NSNotification.Name {
//    static let sharedLocation = NSNotification.Name("sharedLocation")
//}
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//    let manager = CLLocationManager()
//    private let notificationCenter = NotificationCenter.default
//    private override init() { }
//    func checkLocationService() {
//        if CLLocationManager.locationServicesEnabled() {
//            setupLocationManager()
//            checkLocationManagerAuthorization()
//        } else {
//            setupNotificationCenter(object: ["error": true])
//        }
//    }
//    func setupLocationManager() {
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    func checkLocationManagerAuthorization() {
//        switch authorizationStatus() {
//        case .notDetermined:
//            print("Auth: notDetermined")
//            manager.requestWhenInUseAuthorization()
//        case .authorizedAlways, .authorizedWhenInUse:
//            print("Auth: authorizedWhenInUse")
//            manager.startUpdatingLocation()
//        case .denied, .restricted:
//            print("Auth: denied")
//            setupNotificationCenter(object: ["error": true])
//            break
//        default:
//            setupNotificationCenter(object: ["error": true])
//            break
//        }
//    }
//    func authorizationStatus() -> CLAuthorizationStatus {
//        var status: CLAuthorizationStatus
//        if #available(iOS 14.0, *) {
//            status = CLLocationManager().authorizationStatus
//        } else {
//            status = CLLocationManager.authorizationStatus()
//        }
//        return status
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let object: [String: Any] = [
//                "error": false,
//                "location": location
//            ]
//            DispatchQueue.main.async {
//                self.setupNotificationCenter(object: object)
//            }
//            manager.stopUpdatingLocation()
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationService()
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        manager.stopUpdatingLocation()
//    }
//    func setupNotificationCenter(object: Any? = nil) {
//        notificationCenter.post(name: .sharedLocation, object: object)
//    }
//}
