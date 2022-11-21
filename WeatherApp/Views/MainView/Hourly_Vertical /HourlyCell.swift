//
//  HourlyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import WeatherKit

final class HourlyCell: UICollectionViewCell {
    
    // 레이블
    private let hourLabel = Utilities().configLabel(font: 16, weight: .regular)
    private let currentTemp = Utilities().configLabel(font: 16, weight: .regular)
    // 이미지
    private let weatherImg = Utilities().configImange(format: .system, name: "thermometer.high")
    // 스택뷰
    private lazy var stackView = Utilities().configStackView([hourLabel ,weatherImg ,currentTemp], axis: .vertical, alignment: .center)

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
        self.addSubview(stackView)
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configWeather(with hourWeather: HourWeather) {
        let mf = MeasurementFormatter()
        mf.unitOptions = .providedUnit
        mf.numberFormatter.maximumFractionDigits = 0

        let df = DateFormatter()
        df.dateFormat = "h a"
        df.amSymbol = "am"
        df.pmSymbol = "pm"
        
        currentTemp.text = mf.string(from: hourWeather.temperature)
        hourLabel.text = df.string(from: hourWeather.date)
        weatherImg.image = UIImage(systemName: "\(hourWeather.symbolName).fill")
    }
}




// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView4: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif

