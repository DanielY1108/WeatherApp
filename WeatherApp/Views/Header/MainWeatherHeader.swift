//
//  CollectionReusableView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit

final class MainWeatherHeader: UICollectionReusableView {
    
    let weatherManager = WeatherManager.shared
    
    // 레이블
    private let currentTemp = Utilities().configLabel(font: 60, weight: .bold)
    private let highTemp = Utilities().configLabel(font: 16, weight: .regular)
    private let lowTemp = Utilities().configLabel(font: 16, weight: .regular)
    private let weatherStatue = Utilities().configLabel(font: 16, weight: .regular)
    private let currentLocation = Utilities().configLabel(font: 16, weight: .regular)
    private let windSpeed = Utilities().configLabel(font: 16, weight: .regular)
    private let pressure = Utilities().configLabel(font: 16, weight: .regular)
    private let humidity = Utilities().configLabel(font: 16, weight: .regular)
    private let sunrise = Utilities().configLabel(font: 16, weight: .regular)
    private let sunset = Utilities().configLabel(font: 16, weight: .regular)

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
    private lazy var topSideStackView = Utilities().configStackView([currentTemp, highLowStackView, weatherStatue], axis: .vertical)
    private lazy var BottomSideStackView = Utilities().configStackView([pressureStackView, windSpeedStackView, humidityStackView], axis: .horizontal, distribution: .equalSpacing)

    private lazy var hightStackView = Utilities().configStackView([highTempImg, highTemp], axis: .horizontal)
    private lazy var lowStackView = Utilities().configStackView([lowTempImg, lowTemp], axis: .horizontal)
    private lazy var highLowStackView = Utilities().configStackView([hightStackView, lowStackView], axis: .horizontal)

    private lazy var sunriseStackView = Utilities().configStackView([sunriseImg, sunrise], axis: .horizontal)
    private lazy var sunsetStackView = Utilities().configStackView([sunsetImg, sunset], axis: .horizontal)
    private lazy var sunStackView = Utilities().configStackView([sunriseStackView, sunsetStackView], axis: .horizontal)

    private lazy var LocationStackView = Utilities().configStackView([LocationImg, currentLocation], axis: .horizontal)
    
    private lazy var pressureStackView = Utilities().configStackView([pressureImg, pressure], axis: .horizontal, distribution: .fill)
    private lazy var windSpeedStackView = Utilities().configStackView([windSpeedImg, windSpeed], axis: .horizontal, distribution: .fill)
    private lazy var humidityStackView = Utilities().configStackView([humidityImg, humidity], axis: .horizontal,
                                                                distribution: .fill)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        configureUI()
        configureLayout()
        weatherManager.delegate = self
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
            make.top.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(30)
        }
        
        LocationStackView.snp.makeConstraints { make in
            make.top.equalTo(topSideStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(30)
        }
        
        sunStackView.snp.makeConstraints { make in
            make.top.equalTo(topSideStackView.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(30)
        }
        
        BottomSideStackView.snp.makeConstraints { make in
            make.top.equalTo(currentLocation.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(30)
        }
    }
}

// MARK: - CurrentWeatherDelegate
extension MainWeatherHeader: CurrentWeatherDelegate {
    func updateCurrentWeather(model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.currentTemp.text = "\(model.tempStr)°"
            self.highTemp.text = "\(model.tempMaxStr)°"
            self.lowTemp.text = "\(model.tempMinStr)°"
            self.humidity.text = "\(model.humidityStr) %"
            self.windSpeed.text = "\(model.windSpeedStr) m/s"
            self.pressure.text = "\(model.pressureStr) hPa"
            self.currentLocation.text = "\(model.location)"
            self.weatherStatue.text = model.weatherStatue
            self.sunrise.text = model.sunriseStr
            self.sunset.text = model.sunsetStr
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
