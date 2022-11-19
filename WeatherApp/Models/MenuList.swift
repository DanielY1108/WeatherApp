//
//  Menu.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import Foundation

enum Segue {
    case main
    case myList
    case setting
}

struct Menu {
    var title: String
    var segue: Segue
}
