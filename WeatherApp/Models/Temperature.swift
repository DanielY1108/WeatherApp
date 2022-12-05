//
//  Temperature.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/05.
//

import Foundation

enum Temperature {
    case celsius
    case fahrenheit
    
    var option: MeasurementFormatter.UnitOptions {
        switch self {
        case .celsius:
            return .temperatureWithoutUnit
        case .fahrenheit:
            return .naturalScale
        }
    }
}
