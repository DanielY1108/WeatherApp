//
//  UnitTemperature.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/14.
//

import Foundation

enum UnitTemp {
    case celsius
    case fahrenheit
    
    func convertingToString(temperature : Measurement<UnitTemperature>) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        switch self {
        case .celsius:
            let convertTemperature = temperature.converted(to: .celsius)
            mf.unitOptions = .temperatureWithoutUnit
            return mf.string(from: convertTemperature)
        case .fahrenheit:
            let convertTemperature = temperature.converted(to: .fahrenheit)
            mf.unitOptions = .providedUnit
            return mf.string(from: convertTemperature)
        }
    }
}
