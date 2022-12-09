//
//  DetailLicenseController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/12/06.
//

import UIKit

class DetailLicenseController: UIViewController {
    
    var licenseSeleted: License? {
        didSet {
            updateLicense()
        }
    }

    let detailLicenseView = DetailLicenseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        self.view.addSubview(detailLicenseView)
        detailLicenseView.backgroundColor = .systemBackground
        detailLicenseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateLicense() {
        guard let license = licenseSeleted else { return }
        let checkLicenseType = license.type
        DispatchQueue.main.async {
            self.detailLicenseView.mainLabel.text = license.name
            self.detailLicenseView.urlTextView.text = license.url
            switch checkLicenseType {
            case .weatherKit:
                self.detailLicenseView.imageView.image = UIImage(systemName: license.imageName!)
            case .openWeather:
                self.detailLicenseView.imageView.image = UIImage(named: license.imageName!)
            default: break
            }
        }
    }
}
