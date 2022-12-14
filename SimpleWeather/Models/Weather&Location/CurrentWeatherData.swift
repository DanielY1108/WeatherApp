// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct CurrentWeatherData: Codable {
    let coord: Coord
    let weather: [WeatherInfo]
    let main: Main
    let wind: Wind
    let dt: Int
    let name: String
    let sys: Sys
}


// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}
// MARK: - Weather
struct WeatherInfo: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Int
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
