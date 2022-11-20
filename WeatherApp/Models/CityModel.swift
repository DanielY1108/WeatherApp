//
//  CityModel.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import Foundation

struct CityModel: Codable {
    let name: String
    let localNames: [String: String]
    let lat, lon: Double
    let country: String
 
    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country

    }
}

typealias Cities = [CityModel]
