//
//  SubWeatherController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit
import SnapKit
import RealmSwift

final class SubWeatherController: BaseViewController {
    
    private let realmModel = RealmDataModel()
    
    private let buttonView = SubViewButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configWeatherData()
    }
    
    override func configUI() {
        super.configUI()
        collectionView.dataSource = self
        
        self.view.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    func configWeatherData() {
        if let location = locationManager.location {
            weatherManager.fetchFromWeatherKit(reload: collectionView, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SubWeatherController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 12
        default:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.hourlyID, for: indexPath) as! HourlyCell
            if let weatherKit = weatherManager.weatherKit {
                cell.configWeather(with: weatherKit.hourlyForecast[indexPath.item])
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.dailyID, for: indexPath) as! DailyCell
            if let weatherKit = weatherManager.weatherKit {
                let tomorrowIndextPath = indexPath.item + 1
                cell.configWeather(with: weatherKit.dailyForecast[tomorrowIndextPath])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ID.headerID, for: indexPath) as! weatherHeader
        header.weatherData = weatherManager.getWeather()
        if let weatherKit = weatherManager.weatherKit {
            header.configWeather(with: weatherKit.dailyForecast[indexPath.item])
        }
        return header
    }
}



// MARK: - Realm




// MARK: - Button setting

extension SubWeatherController {
    private func setupButtonAction() {
        buttonView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        buttonView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        if let location = locationManager.location {
            realmModel.lat = location.coordinate.latitude
            realmModel.lon = location.coordinate.longitude
            realmManager.write(realmModel)
        }
        weatherManager.AddedWeatherAPI()
        
        dismiss(animated: true)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
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

