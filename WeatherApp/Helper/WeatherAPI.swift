//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/18.
//

import Foundation
import CoreLocation

enum API {
    private static let apiKey = Bundle.main.apiKey
    
    case city(String)
    case coordinate(_ lat :CLLocationDegrees, _ lon: CLLocationDegrees)
    
    var getURLComponent: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        
        switch self {
        case let .city(name):
            components.queryItems = [
                URLQueryItem(name: "q", value: "\(name)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: API.apiKey),
            ]
        case let .coordinate(lat, lon):
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: API.apiKey),
            ]
        }
        return components
    }
}
