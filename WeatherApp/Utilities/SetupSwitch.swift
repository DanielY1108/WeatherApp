//
//  UISwitch+.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/28.
//

import UIKit
protocol SwitchDelegate: AnyObject {
    func locationSwitchChanged(_ sender: UISwitch)
    func unitSwitchChanged(_ sender: UISwitch)
}

