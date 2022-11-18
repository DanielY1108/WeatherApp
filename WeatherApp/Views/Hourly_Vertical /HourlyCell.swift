//
//  HourlyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import WeatherKit

class HourlyCell: UICollectionViewCell {
    
    private let timeLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Time"
        return lable
    }()
    
    private let currentTemp: UILabel = {
        let lable = UILabel()
        lable.text = "Temp"
        return lable
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image11.png")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabel ,weatherImage ,currentTemp])
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(stackView)
    }
    
    func configureLayout() {
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
        timeLabel.text = df.string(from: hourWeather.date)
        weatherImage.image = UIImage(systemName: "\(hourWeather.symbolName).fill")
        print(hourWeather.symbolName)
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

