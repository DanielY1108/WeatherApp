//
//  LocationManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject{
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var location: CLLocation?
}


// MARK: - City list

extension LocationManager {
    func fetchGeoLocation(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Cities) -> Void) {
        let url = WeatherAPI.coordinate(lat, lon).getGeoURLComponent
        self.perfomRequest(url) { result in
            completion(result)
        }
    }
    func fetchGeoLocation(name: String, completion: @escaping (Cities) -> Void) {
        let url = WeatherAPI.city(name).getGeoURLComponent
        self.perfomRequest(url) { result in
            completion(result)
        }
    }
    
    private func perfomRequest(_ urlComponent: URLComponents, completion: @escaping (Cities) -> Void) {
        guard let url = urlComponent.url else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                debugPrint("Error URL: \(error!)")
            }
            guard let safeData = data else {
                debugPrint("Error get Data: \(data!)")
                return
            }
            if let cityModel = self.parseJSON(safeData) {
                completion(cityModel)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> Cities? {
        do {
            let decodeData = try JSONDecoder().decode(Cities.self, from: data)
            return decodeData
        } catch {
            print("Error Parse: \(error)")
            return nil
        }
      
    }
}



// MARK: - Location Delegate

extension LocationManager: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func setupCoordinate() {
        if let location = self.location {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        if let location = locations.first {
            self.location = location
            locationManager.stopUpdatingLocation()
            setupCoordinate()
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
