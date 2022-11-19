//
//  Constants.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation

struct Constants {
    
    struct ID {
        static let headerID = "Header_ID"
        static let categoryHeaderID = "Category_Header_ID"
        
        static let dailyID = "Daily_Cell"
        static let hourlyID = "Hourly_Cell"
        
        static let menuID = "Menu_Cell"
    }
    
    
}
let url1 = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric"
enum Search {
    case city
    case coordinate
}
