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
        
        static let settingID = "Setting_ID"
    }
    struct UserDefault {
        static let locationSwitch = "Location_Switch"
        static let unitSwitch = "Unit_Switch"
    }
    struct NotificationName {
        static let main = "Load_Main"
        static let list = "Load_List"
    }
}

enum Search {
    case city
    case coordinate
}


