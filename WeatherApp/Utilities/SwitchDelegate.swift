//
//  SwitchDelegate.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/05.
//

import UIKit

protocol SwitchDelegate: AnyObject {
    func locationSwitchChanged(_ sender: UISwitch)
    func unitSwitchChanged(_ sender: UISwitch)
}
