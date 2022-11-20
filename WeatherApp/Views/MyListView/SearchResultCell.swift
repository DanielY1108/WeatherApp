//
//  SearchResultCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit

class SearchResultCell: UITableViewCell {

    let cityNameLabel = Utilities().configLabel(font: 18, weight: .regular)
    let countyNameLabel = Utilities().configLabel(font: 18, weight: .regular)
    
    private lazy var stackView = Utilities().configStackView([cityNameLabel, countyNameLabel], axis: .horizontal, distribution: .equalSpacing)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.addSubview(stackView)
        
        cityNameLabel.text = "cityNameLabel"
    
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
