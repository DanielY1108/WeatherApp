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
    
    private let locationLabel = FormatUI.Label(ofSize: .main, weight: .medium).makeLabel
    private let weatherStatueLabel = FormatUI.Label(ofSize: .main, weight: .medium).makeLabel
    private let tempLabel = FormatUI.Label(ofSize: .secondTitle, weight: .medium).makeLabel
    private let highTempLabel = FormatUI.Label(ofSize: .main, weight: .medium).makeLabel
    private let lowTempLabel = FormatUI.Label(ofSize: .main, weight: .medium).makeLabel
    
    private let weatherImg = FormatUI.Image(format: .userImage, name: "2.svg").makeImange
    private let locationImg = FormatUI.Image(format: .systemImage, name: "location").makeImange
    
    private lazy var locationStackView = FormatUI.StackView(subviews: [locationImg, locationLabel],
                                                            axis: .horizontal).makeStackView
    private lazy var highLowStackView = FormatUI.StackView(subviews: [lowTempLabel, highTempLabel],
                                                           axis: .horizontal,
                                                           distribution: .equalCentering).makeStackView
    private lazy var leftSideSatckView =  FormatUI.StackView(subviews: [locationStackView, weatherStatueLabel],
                                                             axis: .vertical,
                                                             distribution: .fillEqually,
                                                             alignment: .leading).makeStackView
    private lazy var rightSideSatckView =  FormatUI.StackView(subviews: [tempLabel, highLowStackView],
                                                              axis: .vertical,
                                                              distribution: .equalCentering,
                                                              alignment: .trailing).makeStackView
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
        self.backgroundColor = #colorLiteral(red: 0.02380630374, green: 0.6114115715, blue: 0.788046062, alpha: 1)
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
            make.top.bottom.equalTo(mainview).inset(10)
            make.trailing.equalTo(mainview).inset(15)
            make.width.equalTo(mainview).multipliedBy(0.4)
        }
    }
}

extension MyListCell {
    func configData() {
        if let weatherData = weatherData {
            DispatchQueue.main.async {
                self.locationLabel.text = weatherData.location
                self.weatherStatueLabel.text = weatherData.weatherStatue
            }
        }
    }
    
    func configWeather(_ weather: Weather, unitTemp: UnitTemp) {
        let currentTemperature = weather.currentWeather.temperature
        let todayWeather = weather.dailyForecast[0]
        let currentTemperatureString = unitTemp.convertingToString(temperature: currentTemperature)
        let highTemperatureString = unitTemp.convertingToString(temperature: todayWeather.highTemperature)
        let LowTemperatureString = unitTemp.convertingToString(temperature: todayWeather.lowTemperature)
        
        tempLabel.text = currentTemperatureString
        highTempLabel.text = "H:\(highTemperatureString)"
        lowTempLabel.text = "L:\(LowTemperatureString)"

    }

}
