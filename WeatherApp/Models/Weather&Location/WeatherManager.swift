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
     func setupWeatherList() {
        DispatchQueue.main.async {
            let weatherData = RealmManager.shared.sort(RealmDataModel.self, by: "date")
            weatherData.forEach { location in
                Task {
                    sleep(1)
                    await self.eachWeatherData(lat: location.lat, lon: location.lon, in: .listViewController)
                    print(location.city)
                }
            }
        }
    }
    func eachWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees, in controller: WeatherVC) async {
        do {
            async let weatherKitData = try await fetchFromWeatherKit(lat: lat, lon: lon)
            async let weatherAPIData = try await fetchFromWeatherAPI(lat: lat, lon: lon)
            switch controller {
            case .mainViewController, .subViewController:
                weatherKit = try await weatherKitData
                weatherModel = try await weatherAPIData
            case .listViewController:
                try await weatherKitList.append(weatherKitData)
                try await weatherModelList.append(weatherAPIData)
            }
        } catch {
            print(error)
        }
    }
    func updateCurrentLoactionWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        Task {
            async let weatherKitData = try await fetchFromWeatherKit(lat: lat, lon: lon)
            async let weatherAPIData = try await fetchFromWeatherAPI(lat: lat, lon: lon)
            weatherKitList[0] = try await weatherKitData
            weatherModelList[0] = try await weatherAPIData
        }
    }
    func deleteWeatherList(indexPath: Int) {
        weatherKitList.remove(at: indexPath)
        weatherModelList.remove(at: indexPath)
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
