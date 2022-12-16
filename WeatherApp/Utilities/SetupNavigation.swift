//
//  SetupNavigation.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/27.
//

import UIKit

enum NavigationList: String {
    case myList = "My List"
    case setting = "Setting"
    case license = "License"
}

struct SetupNavigation {
    private var appearance: UINavigationBarAppearance
    
    init(appearance: UINavigationBarAppearance) {
        self.appearance = appearance
    }
    
    func setup(with viewContoller: UIViewController, title: NavigationList) {
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18.0),
                                          .foregroundColor: UIColor.defaultLabelColor]
        appearance.largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 35.0),
                                               .foregroundColor: UIColor.defaultLabelColor]
        // 기본 설정 (standard, compact, scrollEdge)
        viewContoller.navigationController?.navigationBar.standardAppearance = appearance
        viewContoller.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        viewContoller.navigationController?.navigationBar.prefersLargeTitles = true
        viewContoller.navigationController?.navigationBar.tintColor = .systemBlue  // 틴트색상 설정
        
        viewContoller.navigationItem.title = title.rawValue
        viewContoller.navigationItem.hidesSearchBarWhenScrolling = false  // 검색창 항상 위
    }
}

