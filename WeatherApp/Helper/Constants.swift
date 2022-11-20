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
        
        static let myListID = "MyList_ID"
        static let resultID = "Result_ID"

    }
    
    
}

enum Search {
    case city
    case coordinate
}


