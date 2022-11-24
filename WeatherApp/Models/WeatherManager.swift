//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import UIKit
import WeatherKit
import CoreLocation

final class WeatherManager {
    static let shared = WeatherManager()
    
    private var weatherModel: CurrentWeatherModel?
    private var weatherKit: Weather?
    
    func getWeatherFromAPIModel() -> CurrentWeatherModel? {
        return weatherModel
    }
    
    func getWeatherFromWeatherKit() -> Weather? {
        return weatherKit
    }

    func weatherSet(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Task {
            self.fetchFromWeatherKit(lat: lat, lon: lon) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.enter()
        Task {
            self.fetchFromWeatherAPI(lat: lat, lon: lon) { _ in
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
  
}

// MARK: - WeatherKit

extension WeatherManager {
    func fetchFromWeatherKit(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: CLLocation(latitude: lat, longitude: lon))
                weatherKit = weather
                completion()
            } catch {
                debugPrint(String(describing: error.localizedDescription))
            }
        }
    }
}

// MARK: - OpenWeatherMap

extension WeatherManager {
    
     func fetchFromWeatherAPI(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (CurrentWeatherModel) -> Void) {
        if let url = WeatherAPI.coordinate(lat, lon).getWeatherURLComponent.url {
            performRequest(url) { result in
                self.weatherModel = result
                completion(result)
            }
        }
    }
    
    private func performRequest(_ url: URL, completion: @escaping (CurrentWeatherModel) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                debugPrint(String(describing: error))
                return
            }
            guard let safeData = data else {
                debugPrint(String(describing: error))
                return
            }
            if let weather = self.parseJSON(safeData) {
                completion(weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> CurrentWeatherModel? {
        do {
            let decodeData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            
            let weateherData = CurrentWeatherModel(data: decodeData)
            return weateherData
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}
