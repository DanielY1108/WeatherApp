//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import CoreLocation

final class MainWeatherViewController: UIViewController {
    
    private let menuTableView = UITableView()
    
    private let backgroundView = BackgroundView()
    
    private var currentWeatherModel: CurrentWeatherModel?
    private let weatherManager = WeatherManager.shared
    private let locationManager = LocationManager.shared
    
    private let customLayout = UICollectionViewLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout.createlLayout())
    
    private lazy var menuAnimate = MenuAnimate(menu: false)
    lazy var swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(showMenu(_:)))
    lazy var swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(hideMenu(_:)))
    
    private var menuList: [Menu] = [
        Menu(title: "Main", segue: .main),
        Menu(title: "MyList", segue: .myList),
        Menu(title: "Setting", segue: .setting)
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configSwipeGesture()
        configureCollectionView()
        configMenuTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                        locationManager.setupLocation()
                        defaultWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // 레이아웃 및 서브뷰 관리
    func configUI() {
        self.view.addSubview(backgroundView)
        self.backgroundView.addSubview(menuTableView)
        self.menuTableView.addSubview(collectionView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(80)
            make.width.equalTo(backgroundView).multipliedBy(1.4)
            make.trailing.bottom.equalTo(backgroundView)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(menuTableView)
            make.bottom.equalTo(backgroundView).inset(80)
            make.leading.equalTo(backgroundView).inset(25)
            make.trailing.equalTo(backgroundView).inset(25)
        }
    }
    // 메뉴바
    func configMenuTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        menuTableView.separatorStyle = .none
        menuTableView.register(MenuCell.self, forCellReuseIdentifier: Constants.ID.menuID)
    }
    
    // 제스처 애니매이션
    func configSwipeGesture() {
        menuTableView.addGestureRecognizer(swipeGestureLeft)
        menuTableView.addGestureRecognizer(swipeGestureRight)
        swipeGestureLeft.direction = .left
    }
    func menuSwipeAnimate(action: MenuAction) {
        switch action {
        case .show:
            menuAnimate.showMenu(with: menuTableView, and: collectionView)
        case .hide:
            menuAnimate.hideMenu(with: menuTableView, and: collectionView)
        }
    }
    @objc func showMenu(_ sender: UISwipeGestureRecognizer) {
        if menuAnimate.menu == false && sender.direction == .right {
            menuSwipeAnimate(action: .show)
        }
    }
    @objc func hideMenu(_ sender: UISwipeGestureRecognizer) {
        if menuAnimate.menu == true && sender.direction == .left {
            menuSwipeAnimate(action: .hide)
        }
    }
    
    // 콜렉션뷰
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(weatherHeader.self, forSupplementaryViewOfKind: Constants.ID.categoryHeaderID, withReuseIdentifier: Constants.ID.headerID)
        
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: Constants.ID.dailyID)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: Constants.ID.hourlyID)
    }
    
    func defaultWeather() {
        weatherManager.fetchFromWeatherAPI(lat: 37.566535, lon: 126.97796919999996)
        weatherManager.fetchFromWeatherKit(collectionView, location: CLLocation(latitude: 37.566535, longitude: 126.97796919999996))
    }
}




// MARK: - Menu TableView DataSource

extension MainWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.menuID, for: indexPath) as! MenuCell
        cell.backgroundColor = .clear
        cell.titleLabel.text = menuList[indexPath.row].title
        cell.titleLabel.textColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - Menu TableView Delegate

extension MainWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let currentCell = (tableView.cellForRow(at: indexPath) ?? UITableViewCell())
            
            currentCell.alpha = 0.5
            UIView.animate(withDuration: 1) {
                currentCell.alpha = 1
            }
            
            switch menuList[indexPath.row].segue {
            case .main:
                menuSwipeAnimate(action: .hide)
            case .myList:
                navigationController?.show(MyListViewController(), sender: self)
                menuSwipeAnimate(action: .hide)
            case .setting:
                navigationController?.show(SettingViewController(), sender: self)
                menuSwipeAnimate(action: .hide)
            }
            print(menuList[indexPath.row].segue)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
                cell.configWeather(with: weatherKit.dailyForecast[indexPath.item])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ID.headerID, for: indexPath) as! weatherHeader
        if let currentWeatherModel = currentWeatherModel {
            header.updateCurrentWeather(model: currentWeatherModel)
        }
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension MainWeatherViewController: UICollectionViewDelegate  {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let controller =  UIViewController()
    //        controller.view.backgroundColor = indexPath.section == 0 ? .yellow : .red
    //        present(controller, animated: true)
    //    }
    
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



