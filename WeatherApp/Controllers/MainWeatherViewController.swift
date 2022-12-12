//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit
import SnapKit
import CoreLocation
import WeatherKit


final class MainWeatherViewController: BaseViewController {
        
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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLaunchAppFirstTime()
        configSwipeGesture()
        configMenuTableView()
        setupNotification()
        RealmManager.shared.getLocationOfDefaultRealm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMyCheckWeatherData()
        collectionView.reloadData()
        menuTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(50)
            make.width.equalTo(backgroundView).multipliedBy(1.5)
            make.trailing.bottom.equalTo(backgroundView)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(menuTableView)
            make.bottom.equalTo(backgroundView).inset(40)
            make.leading.equalTo(backgroundView).inset(20)
            make.trailing.equalTo(backgroundView).inset(20)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        collectionView.dataSource = self
        menuTableView.isScrollEnabled = false
        self.view.addSubview(backgroundView)
        self.backgroundView.addSubview(menuTableView)
        self.menuTableView.addSubview(collectionView)
    }
    private func checkLaunchAppFirstTime() {
        if UserDefaults.standard.bool(forKey: Constants.UserDefault.launchAppFirstTime) == false {
            let tutorialVC = TutorialController()
            tutorialVC.modalPresentationStyle = .fullScreen
            present(tutorialVC, animated: false)
            UserDefaults.standard.set(true, forKey: Constants.UserDefault.launchAppFirstTime)
            RealmManager.shared.writeLocation(CLLocationCoordinate2D(), cityName: "Current Location", mainLoad: true)
        }
    }
    private func loadMyCheckWeatherData() {
        RealmManager.shared.read(RealmDataModel.self).forEach { models in
            if models.loadMain == true {
                WeatherManager.shared.getEachWeatherData(lat: models.lat, lon: models.lon, weatherVC: .mainViewController) {
                    self.collectionView.reloadData()
                }
            }
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
                let hourWeather = weathetKit.hourlyForecast[indexPath.item]
                tempUnitSwitch() == false ? cell.configWeather(with: hourWeather, unitTemp: .celsius) : cell.configWeather(with: hourWeather, unitTemp: .fahrenheit)
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.dailyID, for: indexPath) as! DailyCell
            if let weathetKit = WeatherManager.shared.weatherKit {
                let dailyWeather = weathetKit.dailyForecast[indexPath.item + 1]
                tempUnitSwitch() == false ? cell.configWeather(with: dailyWeather, unitTemp: .celsius) : cell.configWeather(with: dailyWeather, unitTemp: .fahrenheit)
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
                tempUnitSwitch() == false ? header.configWeather(weatherKit, unitTemp: .celsius) : header.configWeather(weatherKit, unitTemp: .fahrenheit)
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
// MARK: - Menu TableView DataSource
extension MainWeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return menuList.count
        default:
            return RealmManager.shared.read(RealmDataModel.self).count - 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.menuID, for: indexPath) as! MenuListCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.textColor = .label
            cell.titleLabel.text = menuList[indexPath.row].title
            return cell
        default:
            cell.titleLabel.textColor = .systemIndigo
            cell.titleLabel.text = RealmManager.shared.read(RealmDataModel.self)[indexPath.row + 1].city
            return cell
        }
    }
}
// MARK: - Menu TableView Delegate
extension MainWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
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
                switch LocationManager.shared.manager.authorizationStatus {
                case .denied, .restricted:
                    self.requireLoctionAlert()
                    self.menuSwipeAnimate(action: .hide)
                    print("1")
                case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                    print("2")
                    LocationManager.shared.setupLocationManager()
                    let model = RealmManager.shared.read(RealmDataModel.self)[0]
                    RealmManager.shared.checkLoadMainView(display: model)
                    WeatherManager.shared.getEachWeatherData(lat: model.lat, lon: model.lon, weatherVC: .mainViewController) {
                        self.collectionView.reloadData()
                    }
                    self.menuSwipeAnimate(action: .hide)
                default:
                    print("3")
                }
            }
            print(menuList[indexPath.row].segue)
        default:
            let model = RealmManager.shared.read(RealmDataModel.self)[indexPath.row + 1]
            RealmManager.shared.checkLoadMainView(display: model)
            WeatherManager.shared.getEachWeatherData(lat: model.lat, lon: model.lon, weatherVC: .mainViewController) {
                self.collectionView.reloadData()
            }
            self.menuSwipeAnimate(action: .hide)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        default:
            return 35
        }
    }
}
// MARK: - SwipeGesture & menuList & Animate & alert
extension MainWeatherViewController {
    private func configMenuTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        menuTableView.separatorStyle = .none
        menuTableView.register(MenuListCell.self, forCellReuseIdentifier: Constants.ID.menuID)
    }
    private func configSwipeGesture() {
        menuTableView.addGestureRecognizer(swipeGestureLeft)
        menuTableView.addGestureRecognizer(swipeGestureRight)
        swipeGestureLeft.direction = .left
    }
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
    private func requireLoctionAlert() {
        let arlet = UIAlertController(title: "Required allow access to the location", message: "", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "Setting", style: .default) { action in
            self.navigationController?.show(SettingViewController(), sender: self)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { action in }
        arlet.addAction(goSetting)
        arlet.addAction(cancel)
        present(arlet, animated: true)
    }
}
// MARK: - NotificationCenter
extension MainWeatherViewController {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadMain(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationName.main), object: nil)
    }
    
    @objc func loadMain(notification: NSNotification) {
        switch notification.object {
        case is RealmDataModel:
            guard let coordinate = notification.object as? RealmDataModel else { return }
            WeatherManager.shared.getEachWeatherData(lat: coordinate.lat, lon: coordinate.lon, weatherVC: .mainViewController) {
                self.collectionView.reloadData()
                self.menuTableView.reloadData()
                return
            }
        case is CLLocationCoordinate2D:
            guard let coordinate = notification.object as? CLLocationCoordinate2D else { return }
            WeatherManager.shared.getEachWeatherData(lat: coordinate.latitude, lon: coordinate.longitude, weatherVC: .mainViewController) {
                self.collectionView.reloadData()
                self.menuTableView.reloadData()
                return
            }
        default:
            break
        }
    }
}
// MARK: - UserDefaults tempUnit setting

extension MainWeatherViewController {
    func tempUnitSwitch() -> Bool {
        let unitOption = UserDefaults.standard.bool(forKey: Constants.UserDefault.unitSwitch)
        return unitOption
    }
}
