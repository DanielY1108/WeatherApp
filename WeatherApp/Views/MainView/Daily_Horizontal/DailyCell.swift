//
//  DailyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import WeatherKit

final class DailyCell: UICollectionViewCell {
    
    // 레이블
    private let dayLabel = Utilities().configLabel(font: 16, weight: .regular)
    private let highTempLabel = Utilities().configLabel(font: 16, weight: .regular)
    private let lowTempLabel = Utilities().configLabel(font: 16, weight: .regular)
    // 이미지
    private let weatherImg = Utilities().configImange(name: "thermometer.high", of: .system)
    // 스택뷰
    private lazy var stackViewLeftSide = Utilities().configStackView([dayLabel ,weatherImg], axis: .horizontal, distribution: .equalCentering)
    private lazy var stackViewRightSide = Utilities().configStackView([lowTempLabel, highTempLabel], axis: .horizontal, distribution: .equalCentering)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(stackViewLeftSide)
        self.addSubview(stackViewRightSide)
    }
    
    func configureLayout() {
        stackViewLeftSide.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalToSuperview().inset(14)
        }
        
        stackViewRightSide.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview().inset(20)
            make.width.equalTo(120)
        }
    }
    func configWeather(with dayWeather: DayWeather) {
        let mf = MeasurementFormatter()
        mf.unitOptions = .temperatureWithoutUnit
        mf.numberFormatter.maximumFractionDigits = 0
        let df = DateFormatter()
        df.dateFormat = "E"
        df.locale = Locale(identifier: "en_us")

        
        dayLabel.text = df.string(from: dayWeather.date)
        weatherImg.image = UIImage(systemName: "\(dayWeather.symbolName).fill")
        highTempLabel.text = "H: \(mf.string(from: dayWeather.highTemperature))"
        lowTempLabel.text = "L : \(mf.string(from: dayWeather.lowTemperature))"

    }
    
}


// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView5: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif

    


