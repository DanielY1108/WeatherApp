//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import Foundation
import CoreLocation

enum WeatherAPI {
    private static let apiKey = Bundle.main.apiKey
    
    case city(String)
    case coordinate(_ lat :CLLocationDegrees, _ lon: CLLocationDegrees)
    
    var getWeatherURLComponent: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        
        switch self {
        case let .city(name):
            components.queryItems = [
                URLQueryItem(name: "q", value: "\(name)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: WeatherAPI.apiKey),
            ]
        case let .coordinate(lat, lon):
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: WeatherAPI.apiKey),
            ]
        }
        return components
    }
    
    var getGeoURLComponent: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        switch self {
        case let .city(name):
            components.path = "/geo/1.0/direct"
            components.queryItems = [
                URLQueryItem(name: "q", value: "\(name)"),
                URLQueryItem(name: "appid", value: WeatherAPI.apiKey),
            ]
        case let .coordinate(lat, lon):
            components.path = "/geo/1.0/reverse"
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: WeatherAPI.apiKey),
            ]
        }
        return components
    }
}

enum GeoAPI {
    case coordinate(_ lat :CLLocationDegrees, _ lon: CLLocationDegrees)

}
