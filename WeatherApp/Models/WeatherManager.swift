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
    
    private let realmManager = RealmDataManager.shared
    
    private var weatherModel: CurrentWeatherModel?
    private var weatherModelArray: [CurrentWeatherModel] = []
    private var weatherKit: Weather?
    private var weatherKitArray: [Weather] = []

    private init() {
        updateWeatherData()
        debugPrint("My List Setup Complete")
    }
    
    private func updateWeatherData() {
        realmManager.read(RealmDataModel.self).forEach { location in
            weatherListSet(lat: location.lat, lon: location.lon) { }
        }
    }
    
    func getWeatherFromAPIModel() -> CurrentWeatherModel? {
        return weatherModel
    }
    func getWeatherFromWeatherKit() -> Weather? {
        return weatherKit
    }
    func getWeatherArrayFromAPIModel() -> [CurrentWeatherModel] {
        return weatherModelArray
    }
    func getWeatherArrayFromWeatherKit() -> [Weather] {
        return weatherKitArray
    }
    
    func weatherListSet(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.fetchFromWeatherKit(lat: lat, lon: lon) { model in
            self.weatherKitArray.append(model)
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchFromWeatherAPI(lat: lat, lon: lon) { model in
            self.weatherModelArray.append(model)
            dispatchGroup.leave()
        }
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    
    func weatherSet(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.fetchFromWeatherKit(lat: lat, lon: lon) { _ in
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchFromWeatherAPI(lat: lat, lon: lon) { _ in
            dispatchGroup.leave()
        }
//        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
}

// MARK: - WeatherKit

extension WeatherManager {
    private func fetchFromWeatherKit(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Weather) -> Void) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: CLLocation(latitude: lat, longitude: lon))
                weatherKit = weather
                completion(weather)
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
