//
//  LicenseFooter.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/08.
//

import UIKit

final class LicenseFooter: UICollectionReusableView {
    
    var licenseData: License? {
        didSet {
            guard let licenseData = licenseData else { return }
            configLicenseData(license: licenseData)
        }
    }
    
    private let weatherKitLicenseView = LicenseView()
    private let openWeatherLicenseView = LicenseView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weatherKitLicenseView, openWeatherLicenseView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
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
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configLicenseData(license: License) {
        switch license.type {
        case .weatherKit:
            weatherKitLicenseView.mainLabel.text = license.name
            weatherKitLicenseView.urlTextView.hyperLink(originalText: "more info", hyperLink: "more info", urlString: license.url!)
            weatherKitLicenseView.imageView.image = UIImage(systemName: license.imageName!)
        case .openWeather:
            openWeatherLicenseView.urlTextView.hyperLink(originalText: "more info", hyperLink: "more info", urlString: license.url!)
            openWeatherLicenseView.imageView.image = UIImage(named: license.imageName!)
        default: break
        }
    }
}
