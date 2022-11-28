//
//  SettingModel.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/27.
//

import Foundation

enum SettingTitle: String {
    case location = "Location Setting"
    case temperature = "Temperature Unit"
    case about = "About Weather"
    case openSource = "Open Source License"
    case version = "Version 1.0"
}

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

struct Setting {
    var title: SettingTitle
    var section: SettingSection
    
    init(title: SettingTitle, section: SettingSection) {
        self.title = title
        self.section = section
    }
}
