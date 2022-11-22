//
//  SubViewButton.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit

final class SubViewButton: UIView {
    
    let backButton = UIButton()
    let saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(backButton)
        self.addSubview(saveButton)
        
        backButton.setTitle("back", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        backButton.titleLabel?.textColor = .systemFill
        saveButton.setTitle("add", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        saveButton.titleLabel?.textColor = .systemFill
        
        backButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        saveButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
  
}
