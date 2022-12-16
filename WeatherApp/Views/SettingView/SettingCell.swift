//
//  SettingCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/27.
//

import UIKit

class SettingCell: UITableViewCell {
    
    private let mainView = UIView()
    
    let mainLabel = FormatUI.Label(ofSize: .small, weight: .regular, color: .label).makeLabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(mainView)
        mainView.addSubview(mainLabel)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(mainView)
            make.leading.equalTo(mainView).inset(15)
        }
    }
}
