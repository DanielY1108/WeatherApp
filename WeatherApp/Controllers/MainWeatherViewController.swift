//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit


final class MainWeatherViewController: UIViewController {
    
    private var backgroundView = BackgroundView()
    private var collectionView: UICollectionView?
    private var customLayout = UICollectionViewLayout()
    
    private var currentWeatherModel: CurrentWeatherModel?
    
    let weatherManager = WeatherManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundView)
        configureCollectionView()
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout.createlLayout())
        
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
// MARK: - UICollectionViewDataSource

extension MainWeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 8
        default:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.hourlyID, for: indexPath) as! HourlyCell
            weatherManager.fetchWeather(cityName: "seoul") { listArray in
                cell.forecastWeather = listArray[indexPath.item]
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.dailyID, for: indexPath) as! DailyCell
            weatherManager.fetchWeather(cityName: "seoul") { listArray in
                cell.forecastWeather = listArray[indexPath.item]
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



