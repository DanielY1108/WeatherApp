//
//  UIColor+.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit

extension UIColor {
    static var defaultLabelColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                // ✅ UITraitCollection 의 userInterfaceStyle : 라이트인지 다크인지 알려준다.
                if traitCollection.userInterfaceStyle == .light {
                    return .label
                } else {
                    return .label
                }
            }
        } else {
            return .black
        }
    }
}
