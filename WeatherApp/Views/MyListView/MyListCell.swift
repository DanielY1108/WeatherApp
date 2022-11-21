//
//  MyListCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit

final class MyListCell: UICollectionViewCell {
    private let mainview = UIView()
    
    private let locationLabel = Utilities().configLabel(font: 18, weight: .medium)
    private let weatherStatueLabel = Utilities().configLabel(font: 18, weight: .medium)
    private let tempLabel = Utilities().configLabel(font: 40, weight: .medium)
    private let highTempLabel = Utilities().configLabel(font: 18, weight: .medium)
    private let lowTempLabel = Utilities().configLabel(font: 18, weight: .medium)
    
    private let weatherImg = Utilities().configImange(format: .user, name: "2.svg")
    private let locationImg = Utilities().configImange(format: .user, name: "CurrentLocation.png")
    
    private lazy var locationStackView = Utilities().configStackView([locationImg, locationLabel], axis: .horizontal)
    private lazy var highLowStackView = Utilities().configStackView([lowTempLabel, highTempLabel], axis: .horizontal, distribution: .equalCentering)
    
    private lazy var leftSideSatckView = Utilities().configStackView([locationStackView, weatherStatueLabel], axis: .vertical, distribution: .fillEqually, alignment: .leading)
    private lazy var rightSideSatckView = Utilities().configStackView([tempLabel, highLowStackView], axis: .vertical, distribution: .fillEqually, alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        self.backgroundColor = .lightGray
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(mainview)
        self.mainview.addSubview(weatherImg)
        self.mainview.addSubview(leftSideSatckView)
        self.mainview.addSubview(rightSideSatckView)

        tempLabel.text = "temp"
        highTempLabel.text = "high"
        lowTempLabel.text = "low"
        locationLabel.text = "locationLabel"
        weatherStatueLabel.text = "weatherStatueLabel"
        
    }
    
    private func configureLayout() {
        mainview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        weatherImg.snp.makeConstraints { make in
            make.edges.equalTo(mainview)
        }
        leftSideSatckView.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainview)
            make.leading.equalTo(mainview).offset(20)
            make.width.equalTo(mainview).multipliedBy(0.6)
        }
        rightSideSatckView.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainview)
            make.trailing.equalTo(mainview).offset(20)
            make.width.equalTo(mainview).multipliedBy(0.5)
        }
    }
}


import SwiftUI

#if DEBUG
struct PreView8: PreviewProvider {
    static var previews: some View {
        MyListViewController()
            .toPreview()
    }
}
#endif
