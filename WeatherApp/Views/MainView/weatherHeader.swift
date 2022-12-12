//
//  CollectionReusableView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import WeatherKit

final class weatherHeader: UICollectionReusableView {
    
    var weatherData: CurrentWeatherModel? {
        didSet {
            configWeatherData()
        }
    }
    // 레이블
    private let tempLabel = FormatUI.Label(ofSize: .title, weight: .bold).makeLabel
    private let highTempLabel = FormatUI.Label(ofSize: .main, weight: .regular).makeLabel
    private let lowTempLabel = FormatUI.Label(ofSize: .main, weight: .regular).makeLabel
    private let weatherStatueLabel = FormatUI.Label(ofSize: .medium, weight: .regular).makeLabel
    private let locationLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let windSpeedLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let pressureLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let humidityLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let sunriseLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let sunsetLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    // 이미지
    private let highTempImg = FormatUI.Image(format: .systemImage, name: "thermometer.high").makeImange
    private let lowTempImg = FormatUI.Image(format: .systemImage, name: "thermometer.low").makeImange
    private let LocationImg = FormatUI.Image(format: .systemImage, name: "location").makeImange
    private let pressureImg = FormatUI.Image(format: .systemImage, name: "speedometer").makeImange
    private let windSpeedImg = FormatUI.Image(format: .systemImage, name: "wind").makeImange
    private let humidityImg = FormatUI.Image(format: .systemImage, name: "humidity").makeImange
    private let sunsetImg = FormatUI.Image(format: .systemImage, name: "sunset.fill").makeImange
    private let sunriseImg = FormatUI.Image(format: .systemImage, name: "sunrise.fill").makeImange
    // 스택뷰
    private lazy var topSideStackView = FormatUI.StackView(subviews: [tempLabel, weatherStatueLabel, highLowStackView],
                                                           axis: .vertical,
                                                           alignment: .leading).makeStackView
    private lazy var BottomSideStackView = FormatUI.StackView(subviews: [pressureStackView, windSpeedStackView, humidityStackView],
                                                              axis: .horizontal,
                                                              distribution: .equalSpacing).makeStackView
    private lazy var hightStackView = FormatUI.StackView(subviews: [highTempImg, highTempLabel],
                                                         axis: .horizontal,
                                                         distribution: .equalSpacing).makeStackView
    private lazy var lowStackView = FormatUI.StackView(subviews: [lowTempImg, lowTempLabel],
                                                       axis: .horizontal,
                                                       distribution: .equalSpacing).makeStackView
    private lazy var highLowStackView = FormatUI.StackView(subviews: [lowStackView, hightStackView],
                                                           axis: .horizontal,
                                                           distribution: .fillEqually, spacing: 20).makeStackView
    private lazy var sunriseStackView = FormatUI.StackView(subviews: [sunriseImg, sunriseLabel],
                                                           axis: .horizontal).makeStackView
    private lazy var sunsetStackView = FormatUI.StackView(subviews: [sunsetImg, sunsetLabel],
                                                          axis: .horizontal).makeStackView
    private lazy var sunStackView = FormatUI.StackView(subviews: [sunriseStackView, sunsetStackView],
                                                       axis: .horizontal).makeStackView
    private lazy var LocationStackView =  FormatUI.StackView(subviews: [LocationImg, locationLabel],
                                                             axis: .horizontal).makeStackView
    private lazy var pressureStackView = FormatUI.StackView(subviews: [pressureImg, pressureLabel],
                                                            axis: .horizontal).makeStackView
    private lazy var windSpeedStackView = FormatUI.StackView(subviews: [windSpeedImg, windSpeedLabel],
                                                             axis: .horizontal).makeStackView
    private lazy var humidityStackView = FormatUI.StackView(subviews: [humidityImg, humidityLabel],
                                                            axis: .horizontal).makeStackView
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureUI()
        configureLayout()
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
            make.top.equalToSuperview().inset(10)
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

// MARK: - CurrentWeather Configure Data
extension weatherHeader {
    func configWeatherData() {
        if let weatherData = weatherData {
            DispatchQueue.main.async {
                self.humidityLabel.text = "\(weatherData.humidityStr) %"
                self.windSpeedLabel.text = "\(weatherData.windSpeedStr) m/s"
                self.pressureLabel.text = "\(weatherData.pressureStr) hPa"
                self.locationLabel.text = "\(weatherData.location)"
                self.weatherStatueLabel.text = " \(weatherData.weatherStatue)"
                self.sunriseLabel.text = weatherData.sunriseStr
                self.sunsetLabel.text = weatherData.sunsetStr
            }
        }
    }
    
    func configWeather(_ weather: Weather, unitTemp: UnitTemperature) {
        let mf = MeasurementFormatter()
        mf.unitOptions = .providedUnit
        mf.numberFormatter.maximumFractionDigits = 0
        
        let currentTemperature = weather.currentWeather.temperature
        let convertTemperature = currentTemperature.converted(to: unitTemp)
        
        let todayWeather = weather.dailyForecast[0]
        let convertHighTemperature = todayWeather.highTemperature.converted(to: unitTemp)
        let convertLowTemperature = todayWeather.lowTemperature.converted(to: unitTemp)

        tempLabel.text = mf.string(from: convertTemperature)
        highTempLabel.text = mf.string(from: convertHighTemperature)
        lowTempLabel.text = mf.string(from: convertLowTemperature)

    }
}
