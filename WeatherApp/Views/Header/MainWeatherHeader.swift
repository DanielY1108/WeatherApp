//
//  CollectionReusableView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit

final class MainWeatherHeader: UICollectionReusableView {

    private let currentTemp: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 60, weight: .bold)
        lable.backgroundColor = .green
        lable.text = "Temp"
        return lable
    }()
    
    private let highTemp: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 20, weight: .bold)
        lable.backgroundColor = .green
        lable.text = "high"
        return lable
    }()
    
    private let lowTemp: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 20, weight: .bold)
        lable.backgroundColor = .green
        lable.text = "low"
        return lable
    }()
    
    private let weatherStatue: UILabel = {
        let lable = UILabel()
        lable.backgroundColor = .green
        lable.text = "statue"
        return lable
    }()
    
    private let currentLocation: UILabel = {
        let lable = UILabel()
        lable.textColor = .systemGray
        lable.backgroundColor = .green
        lable.text = "location"
        return lable
    }()
    
    private let windSpeed: UILabel = {
        let lable = UILabel()
        lable.backgroundColor = .green
        lable.text = "wind"
        return lable
    }()
    
    private let pressure: UILabel = {
        let lable = UILabel()
        lable.backgroundColor = .green
        lable.text = "pressure"
        return lable
    }()
    
    private let humidity: UILabel = {
        let lable = UILabel()
        lable.backgroundColor = .green
        lable.text = "humidity"
        return lable
    }()
    
    
    private lazy var stackViewHighLow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highTemp, lowTemp])
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var stackViewTop: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currentTemp, stackViewHighLow, weatherStatue])
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()

    private lazy var stackViewBottom: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pressure, windSpeed, humidity])
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        self.addSubview(stackViewBottom)
        self.addSubview(stackViewTop)
        self.addSubview(currentLocation)
       

    }
    
    func configureLayout() {
        
        stackViewTop.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        
        currentLocation.snp.makeConstraints { make in
            make.top.equalTo(stackViewTop.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        
        stackViewBottom.snp.makeConstraints { make in
            make.top.equalTo(currentLocation.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
    }
    
    
    
    
}


// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView3: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif
