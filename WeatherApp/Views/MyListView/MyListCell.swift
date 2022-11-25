//
//  MyListCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit
import WeatherKit


final class MyListCell: UITableViewCell {
    
    var weatherData: CurrentWeatherModel? {
        didSet {
            configData()
        }
    }
    
    private let mainview = UIView()
    
    private let locationLabel = Utilities().configLabel(font: 18, weight: .medium)
    private let weatherStatueLabel = Utilities().configLabel(font: 18, weight: .medium)
    private let tempLabel = Utilities().configLabel(font: 40, weight: .medium)
    private let highTempLabel = Utilities().configLabel(font: 18, weight: .medium)
    private let lowTempLabel = Utilities().configLabel(font: 18, weight: .medium)
    
    private let weatherImg = Utilities().configImange(format: .user, name: "2.svg")
    private let locationImg = Utilities().configImange(format: .system, name: "location")
    
    private lazy var locationStackView = Utilities().configStackView([locationImg, locationLabel], axis: .horizontal)
    private lazy var highLowStackView = Utilities().configStackView([lowTempLabel, highTempLabel], axis: .horizontal, distribution: .equalCentering)
    
    private lazy var leftSideSatckView = Utilities().configStackView([locationStackView, weatherStatueLabel], axis: .vertical, distribution: .fillEqually, alignment: .leading)
    private lazy var rightSideSatckView = Utilities().configStackView([tempLabel, highLowStackView], axis: .vertical, distribution: .fillEqually, alignment: .center)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
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

extension MyListCell {
    func configData() {
        if let weatherData = weatherData {
            DispatchQueue.main.async {
                self.tempLabel.text = weatherData.tempStr
//                self.highTempLabel.text = weatherData.tempMaxStr
//                self.lowTempLabel.text = weatherData.tempMinStr
                self.locationLabel.text = weatherData.location
                self.weatherStatueLabel.text = weatherData.weatherStatue
            }
        }
    }
    
    func configWeather(with dayWeather: DayWeather) {
        let mf = MeasurementFormatter()
        mf.unitOptions = .temperatureWithoutUnit
        mf.numberFormatter.maximumFractionDigits = 0
        
        highTempLabel.text = "\(mf.string(from: dayWeather.highTemperature))"
        lowTempLabel.text = "\(mf.string(from: dayWeather.lowTemperature))"

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
