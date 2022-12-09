//
//  MuneAnimate.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit

enum MenuAction {
    case show
    case hide
}

struct MenuAnimate {
    // 슬라이드 확인 여부를 Bool로 처리
    var menu: Bool
    
    mutating func showMenu(with tableView: UITableView) {
        let x = tableView.bounds.width * 0.37
        let originalTransform = tableView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
        
        UIView.animate(withDuration: 0.7) {
            tableView.transform = scaledAndTranslatedTransform
        }
        self.menu = true
    }
    
    mutating func hideMenu(with tableView: UITableView) {
        
        UIView.animate(withDuration: 0.7) {
            
            tableView.transform = .identity
        }
        self.menu = false
    }
}
