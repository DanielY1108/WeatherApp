//
//  Constants.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation

struct Constants {
    
    struct ID {
        static let headerID = "headerId"
        static let categoryHeaderID = "categoryHeaderID"
        
        static let dailyID = "dailyCell"
        static let hourlyID = "hourlyCell"
    }
    
    
}
let url1 = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric"
enum Search {
    case city
    case coordinate
}
