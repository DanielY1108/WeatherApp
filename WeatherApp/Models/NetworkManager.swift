//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let apiKey = Bundle.main.apiKey
        
//    let url = "https://api.openweathermap.org/data/2.5/weather"
    let location = "q"
    let appId = "appid="
    let unit = "units=metric"
    
    let url1 = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric"
    
    let url = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid"


    func fetchWeather(cityName: String) {
        let urlStr = "\(url)=\(apiKey)&q=\(cityName)"
        self.performRequset(urlStr)
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
            do {
                let weather = try JSONDecoder().decode(CurrnetWeather.self, from: safeData)
                debugPrint(weather)
            } catch {
                print("Error ParseJSON: \(error)")
            }
        }
        task.resume()
    }
    
    
    
}
