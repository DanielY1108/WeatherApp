//
//  CollectionReusableView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit

final class MainHeaderView: UICollectionReusableView {
    
    let mainView: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(mainView)
    }
    
    func configureLayout() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
