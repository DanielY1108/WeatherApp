//
//  SubWeatherController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit

final class SubWeatherController: MainWeatherViewController {
    
    private var locationManager = LocationManager.shared
    private var weatherManager = WeatherManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
//        print(locationManager.location?.longitude)
//        print(locationManager.location?.latitude)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let location = locationManager.location {
            weatherManager.fetchFromWeatherAPI(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            weatherManager.fetchFromWeatherKit(reload: collectionView, location: location)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
