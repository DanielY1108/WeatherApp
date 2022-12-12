//
//  MenuCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit
import SnapKit

final class MenuListCell: UITableViewCell {

    let titleLabel = FormatUI.Label(ofSize: .medium, weight: .semibold).makeLabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
