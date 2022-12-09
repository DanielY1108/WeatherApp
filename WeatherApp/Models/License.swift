//
//  License.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

enum LicenseName: String {
    case weatherKitName = "WeatherKit"
    case openWeatherName = "OpenWeatherMap"
    case librariesName = "Libraries"
}
enum LicenseUrl: String {
    case weatherKitUrlString = "https://weatherkit.apple.com/legal-attribution.html"
    case openWeatherUrlString = "https://openweathermap.org/"
}
enum LicensImageName: String {
    case weatherKitImageName = "apple.logo"
    case openWeatherImageName = "OpenWeatherLogo.png"
}
enum LicenseType {
    case weatherKit
    case openWeather
    case libraries
}

struct License {
    let type: LicenseType
    let name: LicenseName.RawValue
    var url: LicenseUrl.RawValue?
    var imageName: LicensImageName.RawValue?
    
    init(_ licenseType: LicenseType) {
        self.type = licenseType
        switch licenseType {
        case .weatherKit:
            self.name = LicenseName.weatherKitName.rawValue
            self.url = LicenseUrl.weatherKitUrlString.rawValue
            self.imageName = LicensImageName.weatherKitImageName.rawValue
        case .openWeather:
            self.name = LicenseName.openWeatherName.rawValue
            self.url = LicenseUrl.openWeatherUrlString.rawValue
            self.imageName = LicensImageName.openWeatherImageName.rawValue
        case .libraries:
            self.name = LicenseName.librariesName.rawValue
        }
    }
}
