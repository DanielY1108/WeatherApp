//
//  LocationManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import UIKit
import MapKit
import CoreLocation

final class LocationManager: NSObject{
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var location: CLLocation?
//    var local = 
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // 현제 위치 저장
    func updateLocation(completion: () -> Void) {
        completion()
    }
}

// MARK: - Location Delegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            updateLocation {
                self.location = location
            }
        }
    }
    
    // 실패시
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    // 인증
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
