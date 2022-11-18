//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation
import CoreLocation

protocol CurrentWeatherDelegate: AnyObject {
    func updateCurrentWeather(model: CurrentWeatherModel)
}

class WeatherManager {
    private let apiKey = Bundle.main.apiKey

    static let shared = WeatherManager()
    var delegate: CurrentWeatherDelegate?

    let url1 = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric"
    let url = "https://api.openweathermap.org/data/2.5/"
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let currentUrlStr = "\(url)weather?units=metric&appid=\(apiKey)&lat=\(lat)&lon=\(lon)"
        self.performRequset(currentUrlStr)
        debugPrint(currentUrlStr)
    }

    func fetchWeather(cityName: String) {
        let currentUrlStr = "\(url)weather?units=metric&appid=\(apiKey)&q=\(cityName)"
        self.performRequset(currentUrlStr)
        debugPrint(currentUrlStr)
    }
    
    private func performRequset(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        
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
