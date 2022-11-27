//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import CoreLocation


final class MainWeatherViewController: BaseViewController {
    
    private let weatherManager = WeatherManager.shared
    private let locationManager = LocationManager.shared
    private let realmManager = RealmDataManager.shared
        
    private let menuTableView = UITableView()

    private lazy var swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(showMenu(_:)))
    private lazy var swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(hideMenu(_:)))
    
    private lazy var menuAnimate = MenuAnimate(menu: false)

    private let menuList: [MenuList] = [
        MenuList(title: "Main", segue: .main),
        MenuList(title: "MyList", segue: .myList),
        MenuList(title: "Setting", segue: .setting),
        MenuList(title: "Current location", segue: .currentLocation)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSwipeGesture()
        configMenuTableView()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configUI() {
        collectionView.dataSource = self

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
            make.bottom.equalTo(backgroundView).inset(40)
            make.leading.equalTo(backgroundView).inset(20)
            make.trailing.equalTo(backgroundView).inset(20)
        }
    }
    
}


// MARK: - SwipeGesture & menuList & Animate

extension MainWeatherViewController {
    // 메뉴리스트
    private func configMenuTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        menuTableView.separatorStyle = .none
        menuTableView.register(MenuListCell.self, forCellReuseIdentifier: Constants.ID.menuID)
    }
    // 제스처
    private func configSwipeGesture() {
        menuTableView.addGestureRecognizer(swipeGestureLeft)
        menuTableView.addGestureRecognizer(swipeGestureRight)
        swipeGestureLeft.direction = .left
    }
    // 애니메이션
    private func menuSwipeAnimate(action: MenuAction) {
        switch action {
        case .show:
            menuAnimate.showMenu(with: menuTableView)
        case .hide:
            menuAnimate.hideMenu(with: menuTableView)
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
}

// MARK: - Menu TableView DataSource

extension MainWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.menuID, for: indexPath) as! MenuListCell
        cell.backgroundColor = .clear
        cell.titleLabel.textColor = .white
        cell.selectionStyle = .none
        cell.titleLabel.text = menuList[indexPath.row].title
        
        return cell
    }
}

// MARK: - Menu TableView Delegate

extension MainWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {            
            switch menuList[indexPath.row].segue {
            case .main:
                menuSwipeAnimate(action: .hide)
            case .myList:
                navigationController?.show(MyListViewController(), sender: self)
                menuSwipeAnimate(action: .hide)
            case .setting:
                navigationController?.show(SettingViewController(), sender: self)
                menuSwipeAnimate(action: .hide)
            case .currentLocation:
                locationManager.setupLocation()
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
            if let weathetKit = weatherManager.getSubWeatherFromWeatherKit() {
                cell.configWeather(with: weathetKit.hourlyForecast[indexPath.item])
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.dailyID, for: indexPath) as! DailyCell
            if let weathetKit = weatherManager.getSubWeatherFromWeatherKit() {
                cell.configWeather(with: weathetKit.dailyForecast[indexPath.item + 1])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ID.headerID, for: indexPath) as! weatherHeader
        header.weatherData = weatherManager.getSubWeatherFromAPIModel()
        
        if let weatherKit = weatherManager.getSubWeatherFromWeatherKit() {
            header.configWeather(with: weatherKit.dailyForecast[0])
            }
        return header
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



