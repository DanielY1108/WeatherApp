//
//  SubWeatherController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit
import SnapKit
import CoreLocation
import RealmSwift

final class SubWeatherController: BaseViewController {
    
    var getLocationFromSearch: CLLocationCoordinate2D?
    
    private let buttonView = SubViewButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await getWeatherData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        collectionView.dataSource = self
        self.view.addSubview(buttonView)
    }
    func getWeatherData() async {
        if let coordinate = getLocationFromSearch {
            await WeatherManager.shared.getEachWeatherData(lat: coordinate.latitude, lon: coordinate.longitude, weatherVC: .subViewController)
            self.collectionView.reloadData()
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
            if let weathetKit = WeatherManager.shared.weatherKit {
                unitTempSwitch() == false ? cell.configWeather(with: weathetKit.hourlyForecast[indexPath.item], unitTemp: .celsius) : cell.configWeather(with: weathetKit.hourlyForecast[indexPath.item], unitTemp: .fahrenheit)
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.dailyID, for: indexPath) as! DailyCell
            if let weathetKit = WeatherManager.shared.weatherKit {
                unitTempSwitch() == false ? cell.configWeather(with: weathetKit.dailyForecast[indexPath.item + 1], unitTemp: .celsius) : cell.configWeather(with: weathetKit.dailyForecast[indexPath.item + 1], unitTemp: .fahrenheit)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ID.headerID, for: indexPath) as! weatherHeader
            header.weatherData = WeatherManager.shared.weatherModel
            if let weatherKit = WeatherManager.shared.weatherKit {
                unitTempSwitch() == false ? header.configWeather(weatherKit, unitTemp: .celsius) : header.configWeather(weatherKit, unitTemp: .fahrenheit)
            }
            return header
        default:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ID.footerID, for: indexPath) as! LicenseFooter
            licenses.forEach { license in
                footer.licenseData = license
            }
            return footer
        }
    }
}
// MARK: - Button setting
extension SubWeatherController {
    private func setupButtonAction() {
        buttonView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        buttonView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        guard let coordinate = getLocationFromSearch else { return }
        NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationName.list), object: coordinate)
        dismiss(animated: true)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}
// MARK: - UserDefaults tempUnit setting

extension SubWeatherController {
    func unitTempSwitch() -> Bool {
        let unitOption = UserDefaults.standard.bool(forKey: Constants.UserDefault.unitSwitch)
        return unitOption
    }
}
