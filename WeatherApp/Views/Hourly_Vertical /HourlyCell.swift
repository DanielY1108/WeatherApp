//
//  HourlyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit

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
        image.frame = .init(x: 0, y: 0, width: 100, height: 100)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabel ,weatherImage ,currentTemp])
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
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
        self.addSubview(stackView)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    var forecastWeather: List? {
        didSet {
            configureData()
        }
    }
    
    private func configureData() {
        if let forecastWeather = forecastWeather {
            DispatchQueue.main.async {
                self.timeLabel.text = forecastWeather.hourOfDateStr
                self.currentTemp.text = "\(forecastWeather.main.tempStr)°"
            }
        }
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

