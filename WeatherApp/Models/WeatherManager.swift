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
    
    private var weatherMainModel: CurrentWeatherModel?
    private var weatherMainKit: Weather?
    
    private var weatherListModel: [CurrentWeatherModel] = []
    private var weatherListKit: [Weather] = []
    
    private var weatherSubModel: CurrentWeatherModel?
    private var weatherSubKit: Weather?
    
    
    private init() {
        setupWeatherData()
        debugPrint("My List Setup Complete")
    }
    
    private func setupWeatherData() {
        realmManager.read(RealmDataModel.self).forEach { location in
            listWeatherSet(lat: location.lat, lon: location.lon) { }
        }
    }
    
    // MARK: - Main
    
    func getMainWeatherFromAPIModel() -> CurrentWeatherModel? {
        return weatherMainModel
    }
    func getMainWeatherFromWeatherKit() -> Weather? {
        return weatherMainKit
    }
    
    func mainWeatherSet(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.fetchFromWeatherKit(lat: lat, lon: lon) { _ in
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchFromWeatherAPI(lat: lat, lon: lon) { _ in
            dispatchGroup.leave()
        }
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    

    // MARK: - My List Contoller
    
    func getListWeatherFromAPIModel() -> [CurrentWeatherModel] {
        return weatherListModel
    }
    func getListWeatherFromWeatherKit() -> [Weather] {
        return weatherListKit
    }

    func listWeatherSet(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.fetchFromWeatherKit(lat: lat, lon: lon) { model in
            self.weatherListKit.append(model)
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchFromWeatherAPI(lat: lat, lon: lon) { model in
            self.weatherListModel.append(model)
            dispatchGroup.leave()
        }
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    // MARK: - Sub Weather contolloer
    
    func getSubWeatherFromAPIModel() -> CurrentWeatherModel? {
        return weatherSubModel
    }
    func getSubWeatherFromWeatherKit() -> Weather? {
        return weatherSubKit
    }

    func subWeatherSet(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
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
                weatherSubKit = weather
                completion(weather)
            } catch {
                debugPrint(String(describing: error.localizedDescription))
            }
        }
    }
}

// MARK: - OpenWeatherMap

extension WeatherManager {
    
    private func fetchFromWeatherAPI(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (CurrentWeatherModel) -> Void) {
        if let url = WeatherAPI.coordinate(lat, lon).getWeatherURLComponent.url {
            performRequest(url) { result in
                self.weatherSubModel = result
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
