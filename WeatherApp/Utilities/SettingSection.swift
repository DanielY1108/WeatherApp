//
//  SettingSection.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/27.
//

import Foundation

enum SettingSection: Int{
    static let numberOfSections = 2
    static let titleOfUser = "User Setting"
    static let titleOfInfo = "Info"
    
    case user = 0
    case info = 1
    
    init?(sectionIndex: Int) {
        guard let section = SettingSection(rawValue: sectionIndex) else { return nil }
        self = section
    }
}
