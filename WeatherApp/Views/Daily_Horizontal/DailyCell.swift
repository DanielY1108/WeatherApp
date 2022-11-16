//
//  DailyCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit

class DailyCell: UICollectionViewCell {
    
    private let dayLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Monday"
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
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var stackViewLeftSide: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dayLabel ,weatherImage])
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var stackViewRightSide: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highTemp, lowTemp])
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        self.backgroundColor = .blue
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
        }
        
        stackViewRightSide.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview().inset(20)
        }
    }
    
    var forecastWeather: List? {
        didSet {
            configureDate()
        }
    }
    
    private func configureDate() {
        if let forecastWeather = forecastWeather {
            DispatchQueue.main.async { [self] in
                dayLabel.text = forecastWeather.dayOfDateStr
                highTemp.text = forecastWeather.main.tempMaxStr
                lowTemp.text = forecastWeather.main.tempMinStr
            }
        }
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

    


