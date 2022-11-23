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
    var weatherKit: Weather?
    
    let realmManager = RealmDataManager.shared
    
    private var weatherArray: CurrentWeatherModel?
    var weatherList: [CurrentWeatherModel] = []
    
    var weatherKitList: [DayWeather] = []
        
    private init() {
        RealmWeatherList()
    }
}

// MARK: - Data Setup

extension WeatherManager {
    
    func getWeather() -> CurrentWeatherModel? {
        return weatherArray
    }
    func getWeahterList() -> [CurrentWeatherModel] {
        return weatherList
    }
    
    func getWeahterKitList() -> [DayWeather] {
        return weatherKitList
    }

    func fetchFromWeatherAPI(lat: Double, lon: Double, completion: @escaping () -> Void) {
        self.fetchFromWeatherAPI(lat: lat, lon: lon) { result in
            self.weatherArray = result
            completion()
        }
    }
    
    func AddedWeatherAPI() {
        if let location = realmManager.read(RealmDataModel.self).last {
            fetchFromWeatherAPI(lat: location.lat, lon: location.lon) { result in
                self.weatherList.append(result)
            }
            self.fetchFromWeatherKit(lat: location.lat, lon: location.lon) { result in
                self.weatherKitList.append(result)
            }
        }
    }
    
    private func RealmWeatherList() {
        realmManager.read(RealmDataModel.self).forEach { location in
            self.fetchFromWeatherAPI(lat: location.lat, lon: location.lon) { result in
                self.weatherList.append(contentsOf: [result])
            }
            self.fetchFromWeatherKit(lat: location.lat, lon: location.lon) { result in
                self.weatherKitList.append(result)
            }
            
        }
    }
    
    
}


// MARK: - Get from OpenWeatherMap

extension WeatherManager {
    private func fetchFromWeatherAPI(lat: Double, lon: Double, completion: @escaping (CurrentWeatherModel) -> Void) {
        let urlComponent = WeatherAPI.coordinate(lat, lon).getWeatherURLComponent
        self.performRequset(urlComponent) { result in
            completion(result)
        }
        debugPrint(urlComponent)
    }

    private func fetchFromWeatherAPI(name: String, completion: @escaping (CurrentWeatherModel) -> Void) {
        let urlComponent = WeatherAPI.city(name).getWeatherURLComponent
        self.performRequset(urlComponent) { result in
            completion(result)
        }
        debugPrint(urlComponent)
    }
    
    private func performRequset(_ urlComponent: URLComponents, completion: @escaping (CurrentWeatherModel) -> Void) {
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
                    completion(weather)
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

    func fetchFromWeatherKit(reload collectionView: UICollectionView, lat: Double, lon: Double) {
        Task {
            do {
                let location = CLLocation(latitude: lat, longitude: lon)
                let weather = try await WeatherService.shared.weather(for: location)
                weatherKit = weather
                await collectionView.reloadData()
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    func fetchFromWeatherKit(lat: Double, lon: Double, completion: @escaping (DayWeather) -> Void) {
        Task {
            do {
                let location = CLLocation(latitude: lat, longitude: lon)
                let weather = try await WeatherService.shared.weather(for: location)
                completion(weather.dailyForecast[0])
            } catch {
                print(String(describing: error))
            }
        }
    }
}

// 기본 날씨
//extension WeatherManager {
//    func defaultWeather(reload collectionView: UICollectionView) {
//        fetchFromWeatherAPI(lat: 37.566535, lon: 126.97796919999996) { <#CurrentWeatherModel#> in
//            <#code#>
//        }
//        fetchFromWeatherKit(reload: collectionView, location: CLLocation(latitude: 37.566535, longitude: 126.97796919999996))
//    }
//}
