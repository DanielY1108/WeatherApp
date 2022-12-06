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
    
    private let hourLabel = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let currentTemp = FormatUI.Label(ofSize: .small, weight: .regular).makeLabel
    private let weatherImg = FormatUI.Image(format: .systemImage, name: "thermometer.high").makeImange
    private lazy var stackView = FormatUI.StackView(subviews: [hourLabel ,weatherImg ,currentTemp],
                                                    axis: .vertical,
                                                    alignment: .center).makeStackView

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
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
    
    func configWeather(with hourWeather: HourWeather, tempUnit: MeasurementFormatter.UnitOptions) {
        let mf = MeasurementFormatter()
        mf.unitOptions = tempUnit
        mf.numberFormatter.maximumFractionDigits = 0

        let df = DateFormatter()
        df.dateFormat = "h a"
        df.amSymbol = "am"
        df.pmSymbol = "pm"
        
        currentTemp.text = mf.string(from: hourWeather.temperature)
        hourLabel.text = df.string(from: hourWeather.date)
        weatherImg.image = UIImage(systemName: "\(hourWeather.symbolName)")
    }
}
