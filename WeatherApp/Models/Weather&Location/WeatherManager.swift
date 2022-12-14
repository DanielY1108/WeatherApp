//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import UIKit
import WeatherKit
import CoreLocation

enum WeatherError: Error {
    case invaildLocation
    case invaildUrl
    case invaildResonse
    case invaildData
}

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
        setupWeatherList()
        debugPrint("My List Setup Complete")
    }
    
    func updateCurrentLoactionWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        Task {
            let weatherKitData = try await fetchFromWeatherKit(lat: lat, lon: lon)
            let weatherAPIData = try await fetchFromWeatherAPI(lat: lat, lon: lon)
            weatherKitList[0] = weatherKitData
            weatherModelList[0] = weatherAPIData
        }
    }
    private func setupWeatherList() {
        DispatchQueue.main.async {
            RealmManager.shared.read(RealmDataModel.self).forEach { location in
                Task {
                    await self.eachWeatherData(lat: location.lat, lon: location.lon, in: .listViewController)
                }
            }
        }
    }
    func eachWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees, in controller: WeatherVC) async {
        do {
            let weatherKitData = try await fetchFromWeatherKit(lat: lat, lon: lon)
            let weatherAPIData = try await fetchFromWeatherAPI(lat: lat, lon: lon)
            switch controller {
            case .mainViewController, .subViewController:
                weatherKit = weatherKitData
                weatherModel = weatherAPIData
            case .listViewController:
                weatherKitList.append(weatherKitData)
                weatherModelList.append(weatherAPIData)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - WeatherKit
extension WeatherManager {
    private func fetchFromWeatherKit(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> Weather {
        let weather = try await WeatherService.shared.weather(for: CLLocation(latitude: lat, longitude: lon))
        return weather
    }
}

// MARK: - OpenWeatherMap

extension WeatherManager {
    private func fetchFromWeatherAPI(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> CurrentWeatherModel {
        guard let url = WeatherAPI.coordinate(lat, lon).getWeatherURLComponent.url else { throw WeatherError.invaildUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = (response as? HTTPURLResponse), (200 ..< 299) ~= response.statusCode else { throw WeatherError.invaildResonse }
        do {
            let parseJSON = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            let weatherData = CurrentWeatherModel(data: parseJSON)
            return weatherData
        } catch {
            throw WeatherError.invaildData
        }
    }
}
