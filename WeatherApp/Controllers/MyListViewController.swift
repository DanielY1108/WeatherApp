//
//  MyListController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit

class MyListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        self.view.backgroundColor = .red
    }
    
    func configNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18.0),
                                          .foregroundColor: UIColor.systemGreen]      // 글자 설정
        // 기본 설정 (standard, compact, scrollEdge)
        self.navigationController?.navigationBar.standardAppearance = appearance
       //self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.title = "My List"
        self.navigationController?.navigationBar.tintColor = .white  // 틴트색상 설정
//        self.navigationItem.hidesSearchBarWhenScrolling = false  // 검색창 항상 위

        // 탭바 오른쪽 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tabBarButtonTapped))
    }
    
    @objc func tabBarButtonTapped() {
        
    }
    

}



import SwiftUI

#if DEBUG
struct PreView7: PreviewProvider {
    static var previews: some View {
        MyListViewController()
            .toPreview()
    }
}
#endif
