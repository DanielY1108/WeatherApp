//
//  DailyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import WeatherKit

final class DailyCell: UICollectionViewCell {
    
    // 레이블
    private let dayLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let highTempLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let lowTempLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    // 이미지
    private let weatherImg = FormatUI.Image(format: .systemImage, name: "thermometer.high").makeImange
    // 스택뷰
    private lazy var stackViewLeftSide = FormatUI.StackView(subviews: [dayLabel ,weatherImg],
                                                            axis: .horizontal,
                                                            distribution: .equalCentering).makeStackView
    private lazy var stackViewRightSide = FormatUI.StackView(subviews: [lowTempLabel, highTempLabel],
                                                             axis: .horizontal,
                                                             distribution: .equalSpacing).makeStackView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(stackViewLeftSide)
        self.addSubview(stackViewRightSide)
    }
    
    private func configureLayout() {
        stackViewLeftSide.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalToSuperview().inset(14)
        }
        stackViewRightSide.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview().inset(20)
            make.width.equalTo(140)
        }
    }
    func configWeather(with dayWeather: DayWeather, tempUnit: MeasurementFormatter.UnitOptions) {
        let mf = MeasurementFormatter()
        mf.unitOptions = tempUnit
        mf.numberFormatter.maximumFractionDigits = 0
        let df = DateFormatter()
        df.dateFormat = "E"
        df.locale = Locale(identifier: "en_us")

        dayLabel.text = df.string(from: dayWeather.date)
        weatherImg.image = UIImage(systemName: "\(dayWeather.symbolName)")
        highTempLabel.text = "H: \(mf.string(from: dayWeather.highTemperature))"
        lowTempLabel.text = "L: \(mf.string(from: dayWeather.lowTemperature))"
    }
}

