//
//  SearchResultCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit

final class SearchCell: UITableViewCell {

    let cityNameLabel = Utilities().configLabel(font: 18, weight: .regular)
    let countyNameLabel = Utilities().configLabel(font: 14, weight: .regular)
    
    private lazy var stackView = Utilities().configStackView([cityNameLabel, countyNameLabel], axis: .horizontal, distribution: .equalSpacing)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(cityNameLabel)
        self.addSubview(countyNameLabel)
        
        cityNameLabel.numberOfLines = 0
        countyNameLabel.textAlignment = .right
        
        cityNameLabel.text = "cityNameLabel"
        countyNameLabel.text = "countyNameLabel"
        
        cityNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        countyNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.2)
            
        }
    }

}
