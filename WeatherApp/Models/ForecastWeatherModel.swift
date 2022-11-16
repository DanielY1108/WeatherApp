//
//  ForecastWeatherModel.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/17.
//

import Foundation

// MARK: - ForecastWeatherData
struct ForecastWeatherModel: Codable {
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let date: Int
    let main: ForcastWeather
    let weather: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main, weather
    }

    var hourOfDateStr: String {
        let timeInterval = date
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "H a"
        dateformatter.pmSymbol = "pm"
        dateformatter.amSymbol = "am"
        dateformatter.timeZone = NSTimeZone(name: "KOR") as TimeZone?
        let time = dateformatter.string(from: date as Date)
        return time
    }
    var dayOfDateStr: String {
        let timeInterval = date
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "E"
        dateformatter.timeZone = NSTimeZone(name: "KOR") as TimeZone?
        let time = dateformatter.string(from: date as Date)
        return time
    }
}

// MARK: - MainWeather
struct ForcastWeather: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    var tempStr: String {
        return String(format: "%.0f", temp)
    }
    
    var tempMinStr: String {
        return String(format: "%.0f", tempMin)
    }
    
    var tempMaxStr: String {
        return String(format: "%.0f", tempMax)
    }
}

// MARK: - WeatherCondition
struct WeatherCondition: Codable {
    let id: Int
}



