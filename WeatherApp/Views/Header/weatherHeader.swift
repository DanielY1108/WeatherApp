//
//  CollectionReusableView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit

final class weatherHeader: UICollectionReusableView {
    
    let weatherManager = WeatherManager.shared
    
    // 레이블
    private let tempLabel = Utilities().configLabel(font: 60, weight: .bold)
    private let highTempLabel = Utilities().configLabel(font: 18, weight: .regular)
    private let lowTempLabel = Utilities().configLabel(font: 18, weight: .regular)
    private let weatherStatueLabel = Utilities().configLabel(font: 20, weight: .regular)
    private let locationLabel = Utilities().configLabel(font: 15, weight: .regular)
    private let windSpeedLabel = Utilities().configLabel(font: 15, weight: .regular)
    private let pressureLabel = Utilities().configLabel(font: 15, weight: .regular)
    private let humidityLabel = Utilities().configLabel(font: 15, weight: .regular)
    private let sunriseLabel = Utilities().configLabel(font: 15, weight: .regular)
    private let sunsetLabel = Utilities().configLabel(font: 15, weight: .regular)

    // 이미지
    private let highTempImg = Utilities().configImange(name: "thermometer.high", of: .system)
    private let lowTempImg = Utilities().configImange(name: "thermometer.low", of: .system)
    private let LocationImg = Utilities().configImange(name: "CurrentLocation.png", of: .user)
    private let pressureImg = Utilities().configImange(name: "speedometer", of: .system)
    private let windSpeedImg = Utilities().configImange(name: "wind", of: .system)
    private let humidityImg = Utilities().configImange(name: "humidity", of: .system)
    private let sunsetImg = Utilities().configImange(name: "sunset.fill", of: .system)
    private let sunriseImg = Utilities().configImange(name: "sunrise.fill", of: .system)

    // 스택뷰
    private lazy var topSideStackView = Utilities().configStackView([tempLabel, weatherStatueLabel, highLowStackView], axis: .vertical)
    private lazy var BottomSideStackView = Utilities().configStackView([pressureStackView, windSpeedStackView, humidityStackView], axis: .horizontal, distribution: .equalSpacing)

    private lazy var hightStackView = Utilities().configStackView([highTempImg, highTempLabel], axis: .horizontal, distribution: .fillEqually)
    private lazy var lowStackView = Utilities().configStackView([lowTempImg, lowTempLabel], axis: .horizontal, distribution: .fillEqually)
    private lazy var highLowStackView = Utilities().configStackView([lowStackView, hightStackView], axis: .horizontal, distribution: .equalCentering)

    private lazy var sunriseStackView = Utilities().configStackView([sunriseImg, sunriseLabel], axis: .horizontal)
    private lazy var sunsetStackView = Utilities().configStackView([sunsetImg, sunsetLabel], axis: .horizontal)
    private lazy var sunStackView = Utilities().configStackView([sunriseStackView, sunsetStackView], axis: .horizontal)

    private lazy var LocationStackView = Utilities().configStackView([LocationImg, locationLabel], axis: .horizontal)
    
    private lazy var pressureStackView = Utilities().configStackView([pressureImg, pressureLabel], axis: .horizontal, distribution: .fill)
    private lazy var windSpeedStackView = Utilities().configStackView([windSpeedImg, windSpeedLabel], axis: .horizontal, distribution: .fill)
    private lazy var humidityStackView = Utilities().configStackView([humidityImg, humidityLabel], axis: .horizontal, distribution: .fill)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureUI()
        configureLayout()
        weatherManager.delegate = self
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(topSideStackView)
        self.addSubview(LocationStackView)
        self.addSubview(BottomSideStackView)
        self.addSubview(sunStackView)
    }
    
    private func configureLayout() {
        topSideStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.equalToSuperview().inset(20)
        }
        
        LocationStackView.snp.makeConstraints { make in
            make.top.equalTo(topSideStackView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
        }
        
        sunStackView.snp.makeConstraints { make in
            make.top.equalTo(topSideStackView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().inset(20)
        }
        
        BottomSideStackView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
}

// MARK: - CurrentWeatherDelegate
extension weatherHeader: CurrentWeatherDelegate {
    func updateCurrentWeather(model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = "\(model.tempStr)°"
            self.highTempLabel.text = "\(model.tempMaxStr)°"
            self.lowTempLabel.text = "\(model.tempMinStr)°"
            self.humidityLabel.text = "\(model.humidityStr) %"
            self.windSpeedLabel.text = "\(model.windSpeedStr) m/s"
            self.pressureLabel.text = "\(model.pressureStr) hPa"
            self.locationLabel.text = "\(model.location)"
            self.weatherStatueLabel.text = model.weatherStatue
            self.sunriseLabel.text = model.sunriseStr
            self.sunsetLabel.text = model.sunsetStr
        }
    }
}


// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView3: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif
