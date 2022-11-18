//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import UIKit
import WeatherKit
import CoreLocation

protocol CurrentWeatherDelegate: AnyObject {
    func updateCurrentWeather(model: CurrentWeatherModel)
}

class WeatherManager {
    static let shared = WeatherManager()
    var delegate: CurrentWeatherDelegate?
    var weatherKit: Weather?
}

// MARK: - Get from OpenWeatherMap
extension WeatherManager {
    func fetchFromWeatherAPI(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlComponent = API.coordinate(lat, lon).getURLComponent
        self.performRequset(urlComponent)
        debugPrint(urlComponent)
    }

    func fetchFromWeatherAPI(name: String) {
        let urlComponent = API.city(name).getURLComponent
        self.performRequset(urlComponent)
        debugPrint(urlComponent)
    }
    
    private func performRequset(_ urlComponent: URLComponents) {
        guard let url = urlComponent.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error URL: \(error!)")
            }
            guard let safeData = data else {
                print("Error Data: \(error!)")
                return
            }
                if let weather = self.parseJSONCurrent(safeData) {
                    self.delegate?.updateCurrentWeather(model: weather)
            }
        }
        task.resume()
    }
    
    private func parseJSONCurrent(_ safeData: Data) -> CurrentWeatherModel? {
        do {
            let decodeData = try JSONDecoder().decode(CurrentWeatherData.self, from: safeData)
            
            let currentWeather = CurrentWeatherModel(data: decodeData)
            return currentWeather
        } catch {
            print("Error ParseJSON: \(error)")
            return nil
        }
    }
}

// MARK: - Get from WeatherKit
extension WeatherManager {

    func fetchFromWeatherKit(_ collectionView: UICollectionView, location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                weatherKit = weather
                await collectionView.reloadData()
            } catch {
                print(String(describing: error))
            }
        }
    }
    
}
