//
//  License.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

enum LicenseImage: String {
    case openWeather = "OpenWeatherLogo.png"
    case snapkit = "SnapKitLogo.png"
    case realm = "RealmLogo.png"
    case weatherKit = "apple.logo"
}

enum LicenseType: String {
    case openWeather = "OpenWeatherMap"
    case snapkit = "SnapKit"
    case realm = "Realm"
    case weatherKit = "Apple WeatherKit"
}

struct Licenses {
    let name: LicenseType
    init(name: LicenseType) {
        self.name = name
    }
}

struct DetailLicense {
    var name: LicenseType
    var info: String
    var imageName: LicenseImage
}
