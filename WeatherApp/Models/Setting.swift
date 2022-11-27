//
//  SettingModel.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/27.
//

import Foundation

struct Setting {
    var title: SettingTitle
    var section: SettingSection
    
    init(title: SettingTitle, section: SettingSection) {
        self.title = title
        self.section = section
    }
}
