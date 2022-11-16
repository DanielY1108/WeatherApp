//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation

protocol CurrentWeatherDelegate: AnyObject {
    func updateCurrentWeather(model: CurrentWeatherModel)
}
protocol ForecastWeatherDelegate: AnyObject {
    func updateForecastWeather(model: ForecastWeatherModel)
}


enum WeatherType {
    case current
    case forecast
}

class WeatherManager {
    
    static let shared = WeatherManager()
    private let apiKey = Bundle.main.apiKey
    
    var delegate: CurrentWeatherDelegate?

    let url1 = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric"
    
    let url = "https://api.openweathermap.org/data/2.5/"

    func fetchWeather(cityName: String, completion: @escaping ([List]) -> Void) {
        let currentUrlStr = "\(url)weather?units=metric&appid=\(apiKey)&q=\(cityName)"
        let forecastUrlStr = "\(url)forecast?units=metric&appid=\(apiKey)&q=\(cityName)"
        
        self.performRequset(currentUrlStr, forecast: .current) {_ in }
        self.performRequset(forecastUrlStr, forecast: .forecast) { listArray in
            completion(listArray)
        }
        debugPrint(currentUrlStr, forecastUrlStr)
    }
    
    private func performRequset(_ urlStr: String, forecast: WeatherType, completion: @escaping ([List]) -> Void) {
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error URL: \(error!)")
            }
            guard let safeData = data else {
                print("Error Data: \(error!)")
                return
            }
            switch forecast {
            case .current:
                if let weather = self.parseJSONCurrent(safeData) {
                    self.delegate?.updateCurrentWeather(model: weather)
            }
            case .forecast:
                if let weather = self.parseJSONForecast(safeData) {
                    completion(weather.list)
                }
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
    
    private func parseJSONForecast(_ safeData: Data) -> ForecastWeatherModel? {
        do {
            let decodeData = try JSONDecoder().decode(ForecastWeatherModel.self, from: safeData)
            let forecastWeather = ForecastWeatherModel(list: decodeData.list)
            return forecastWeather
        } catch {
            print("Error ParseJSON: \(error)")
            return nil
        }
    }
    
    
}
