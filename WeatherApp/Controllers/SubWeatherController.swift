//
//  SubWeatherController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit
import SnapKit

final class SubWeatherController: BaseViewController {
    
    private let buttonView = SubViewButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let location = locationManager.location {
            weatherManager.fetchFromWeatherAPI(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            weatherManager.fetchFromWeatherKit(reload: collectionView, location: location)
        }
    }
 
    override func configUI() {
        super.configUI()
        self.view.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    private func setupButtonAction() {
        buttonView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        buttonView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        
    }

    @objc func backButtonTapped() {
        
    }



}


import SwiftUI

#if DEBUG
struct PreView11: PreviewProvider {
    static var previews: some View {
        SubWeatherController()
            .toPreview()
    }
}
#endif

