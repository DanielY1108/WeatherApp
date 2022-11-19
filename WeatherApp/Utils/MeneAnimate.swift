//
//  MuneAnimate.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit

struct MenuAnimate {
    // 슬라이드 확인 여부를 Bool로 처리
    var menu: Bool
    // 새로운 그리는 좌표를 구하는데 필요하다
    var home: CGAffineTransform
    
    mutating func showMenu(view: UIView, with collectionView: UICollectionView) {
        let x = view.bounds.width * 0.3
        let originalTransform = collectionView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.9, y: 0.9)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
        
        UIView.animate(withDuration: 0.7) {
            collectionView.transform = scaledAndTranslatedTransform
        }
        self.menu = true
    }
    
    mutating func hideMenu(collectionView: UICollectionView, defualtSize: CGAffineTransform) {
        UIView.animate(withDuration: 0.7) {
            collectionView.transform = defualtSize
        }
        self.menu = false
    }
}
