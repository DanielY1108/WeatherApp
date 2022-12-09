//
//  DetailLicenseView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class DetailLicenseView: UIView {
    let mainLabel = UILabel()
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    let urlTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.dataDetectorTypes = .link
        view.textColor = .label
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainLabel, urlTextView])
        stack.axis = .vertical
        stack.spacing = 10
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
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
    }
}

