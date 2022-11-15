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

class WeatherManager {
    
    static let shared = WeatherManager()
    private let apiKey = Bundle.main.apiKey
    
    private var currentWeatherModel: CurrentWeatherModel?

    var delegate: CurrentWeatherDelegate?
    
        
//    let url = "https://api.openweathermap.org/data/2.5/weather"
    let location = "q"
    let appId = "appid="
    let unit = "units=metric"
    
    let url1 = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric"
    
    let url = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid"


    func fetchWeather(cityName: String) {
        let urlStr = "\(url)=\(apiKey)&q=\(cityName)"
        self.performRequset(urlStr)
        debugPrint(urlStr)
    }
    
    func performRequset(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error URL: \(error!)")
            }
            guard let safeData = data else {
                print("Error Data: \(error!)")
                return
            }
            if let weather = self.parseJSON(safeData) {
                self.delegate?.updateCurrentWeather(model: weather)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ safeData: Data) -> CurrentWeatherModel? {
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
