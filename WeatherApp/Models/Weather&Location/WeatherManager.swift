//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import UIKit
import WeatherKit
import CoreLocation

enum WeatherVC {
    case mainViewController
    case listViewController
    case subViewController
}

final class WeatherManager {
    static let shared = WeatherManager()
    
    private(set) var weatherModel: CurrentWeatherModel?
    private(set) var weatherKit: Weather?
    private(set) var weatherModelList: [CurrentWeatherModel] = []
    private(set) var weatherKitList: [Weather] = []
    
    private init() {
        setupWeatherData()
        debugPrint("My List Setup Complete")
    }
    
    private func setupWeatherData() {
        RealmManager.shared.read(RealmDataModel.self).forEach { location in
            getEachWeatherData(lat: location.lat, lon: location.lon, weatherVC: .listViewController) {}
        }
    }
    
    func getEachWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees, weatherVC: WeatherVC , completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.fetchFromWeatherKit(lat: lat, lon: lon) { model in
            switch weatherVC {
            case .mainViewController, .subViewController:
                self.weatherKit = model
            case .listViewController:
                self.weatherKitList.append(model)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchFromWeatherAPI(lat: lat, lon: lon) { model in
            switch weatherVC {
            case .mainViewController, .subViewController:
                self.weatherModel = model
            case .listViewController:
                self.weatherModelList.append(model)
            }
            dispatchGroup.leave()
        }
//        if weatherVC == .listViewController {
//            dispatchGroup.wait()
//        }
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
