//
//  SearchResultCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit

final class SearchCell: UITableViewCell {

    let cityNameLabel = FormatUI.Label(ofSize: .small, weight: .regular, color: .label).makeLabel
    let countyNameLabel = FormatUI.Label(ofSize: .Annotation, weight: .regular, color: .label).makeLabel
    
    private lazy var stackView = FormatUI.StackView(subviews: [cityNameLabel, countyNameLabel],
                                                    axis: .horizontal,
                                                    distribution: .equalSpacing).makeStackView
    
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
            make.top.equalToSuperview().inset(2)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        countyNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}
