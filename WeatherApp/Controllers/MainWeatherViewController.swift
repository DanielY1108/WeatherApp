//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import WeatherKit
import CoreLocation


final class MainWeatherViewController: UIViewController {
    
  
    private var backgroundView = BackgroundView()
    
    private var currentWeatherModel: CurrentWeatherModel?
    
    private let weatherManager = WeatherManager.shared
    
    private var weatherKit: Weather?
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private var hourlyCast = HourlyCell()
    
    let customLayout = UICollectionViewLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout.createlLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundView)
        configureCollectionView()
        weatherManager.fetchWeather(lat: 10, lon: 100)
        getWeather(location: CLLocation(latitude: 10, longitude: 100))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func configureCollectionView() {
     
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(MainWeatherHeader.self, forSupplementaryViewOfKind: Constants.ID.categoryHeaderID, withReuseIdentifier: Constants.ID.headerID)
        
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: Constants.ID.dailyID)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: Constants.ID.hourlyID)
        
        self.backgroundView.addSubview(collectionView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView)
            make.bottom.leading.trailing.equalTo(backgroundView).inset(20)
        }
    }
}

// MARK: - WeatherKit

extension MainWeatherViewController {
    func getWeather(location: CLLocation) {
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                weatherKit = weather
                collectionView.reloadData()
            } catch {
                print(String(describing: error))
            }
        }
    }
}

// MARK: - Location Delegate

extension MainWeatherViewController: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        if let location = locations.first {
            currentLocation = location
            getWeather(location: location)
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        print(lat, lon)
    }
}



// MARK: - UICollectionViewDataSource

extension MainWeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 12
        default:
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.hourlyID, for: indexPath) as! HourlyCell
            if let weatherKit = weatherKit {
                cell.configWeather(with: weatherKit.hourlyForecast[indexPath.item])
            }
            return cell

        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.dailyID, for: indexPath) as! DailyCell
            if let weatherKit = weatherKit {
                cell.configWeather(with: weatherKit.dailyForecast[indexPath.item])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ID.headerID, for: indexPath) as! MainWeatherHeader
        if let currentWeatherModel = currentWeatherModel {
            header.updateCurrentWeather(model: currentWeatherModel)
        }
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension MainWeatherViewController: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller =  UIViewController()
        controller.view.backgroundColor = indexPath.section == 0 ? .yellow : .red
        present(controller, animated: true)
    }
}






// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif



