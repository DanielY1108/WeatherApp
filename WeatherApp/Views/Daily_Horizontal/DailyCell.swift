//
//  DailyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import WeatherKit

class DailyCell: UICollectionViewCell {
    
    private let dayLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Sun"
        return lable
    }()
    
    private let highTemp: UILabel = {
        let lable = UILabel()
        lable.text = "high"
        return lable
    }()
    
    private let lowTemp: UILabel = {
        let lable = UILabel()
        lable.text = "low"
        return lable
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image11.png")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var stackViewLeftSide: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dayLabel ,weatherImage])
        stack.spacing = 20
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var stackViewRightSide: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lowTemp, highTemp])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .fill
        return stack
    }()

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
            make.width.equalTo(90)
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
        weatherImage.image = UIImage(systemName: "\(dayWeather.symbolName).fill")
        highTemp.text = "H: \(mf.string(from: dayWeather.highTemperature))"
        lowTemp.text = "L : \(mf.string(from: dayWeather.lowTemperature))"

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

    


