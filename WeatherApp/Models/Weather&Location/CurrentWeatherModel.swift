//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/15.
//

import Foundation

struct CurrentWeatherModel {
    private var temp, tempMax, tempMin, windSpeed: Double
    private var humidity, pressure ,sunrise, sunset: Int
    
    let weatherStatue: String
    let location: String
    
    var tempStr: String {
        return String(format: "%.0f", temp)
    }
    var tempMaxStr: String {
        return String(format: "%.0f", tempMax)
    }
    var tempMinStr: String {
        return String(format: "%.0f", tempMin)
    }
    var windSpeedStr: String {
        return String(format: "%.0f", windSpeed)
    }
    var pressureStr: String {
        return String(pressure)
    }
    var humidityStr: String {
        return String(humidity)
    }
    var sunriseStr: String {
        let timeInterval = sunrise
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let time = dateformatter.string(from: date as Date)
        return time
    }
    var sunsetStr: String {
        let timeInterval = sunset
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let time = dateformatter.string(from: date as Date)
        return time
        
    }
    
    init(data: CurrentWeatherData) {
        temp = data.main.temp
        tempMax = data.main.tempMax
        tempMin = data.main.tempMin
        pressure = data.main.pressure
        windSpeed = data.wind.speed
        humidity = data.main.humidity
        weatherStatue = data.weather[0].weatherDescription
        location = data.name
        sunrise = data.sys.sunrise
        sunset = data.sys.sunset
    }
}
