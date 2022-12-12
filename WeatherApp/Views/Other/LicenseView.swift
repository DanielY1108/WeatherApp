//
//  LicenseView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/08.
//

import UIKit

class LicenseView: UIView {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    let imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    let urlTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isEditable = false
        view.isScrollEnabled = false
        view.dataDetectorTypes = .link
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 12)
        return view
    }()
 
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, mainLabel, urlTextView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        self.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing)
            make.width.equalTo(mainLabel)
        }
        self.addSubview(urlTextView)
        urlTextView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(mainLabel.snp.trailing).offset(5)
            
        }
    }
}
