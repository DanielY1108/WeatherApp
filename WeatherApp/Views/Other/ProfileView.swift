//
//  ProfileView.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/12.
//

import UIKit

class ProfileView: UIView {
    
    private let appLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .bold)
        return label
    }()
    private let appImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let emailTextView: UITextView = {
        let view = UITextView()
        view.textColor = .label
        view.isEditable = false
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    private let createLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appLabel ,creatorLabel, emailTextView, createLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = . center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.addSubview(appImageView)
        appImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(100)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        self.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    func setupUI() {
        appImageView.image = UIImage(named: "AppIcon.png")
        appLabel.text = "WeatherApp"
        creatorLabel.text = "Create by JINSEOK YANG"
        createLabel.text = "Created 2022/12/12"
        emailTextView.text = "scarlet040@gmail.com"
    }
    
    
}
