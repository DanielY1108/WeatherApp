//
//  RealmLocation.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import Foundation
import RealmSwift

final class RealmDataModel: Object {
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
}
