//
//  MyListController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit
import SnapKit
import RealmSwift
import CoreLocation

final class MyListViewController: UIViewController {
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let searchController = UISearchController(searchResultsController: SearchLocationController())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        setupSearchBar()
        configureUI()
        setupKeyboardEvent()
        setupNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func configureUI() {
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyListCell.self, forCellReuseIdentifier: Constants.ID.myListID)
    }
}
// MARK: - UITableViewDataSource {
extension MyListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return RealmManager.shared.read(RealmDataModel.self).count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.myListID, for: indexPath) as! MyListCell
        
        cell.weatherData = WeatherManager.shared.weatherModelList[indexPath.section]
        
        let weatherKit = WeatherManager.shared.weatherKitList[indexPath.section]
        cell.configWeather(with: weatherKit.dailyForecast[0])
        
        cell.selectionStyle = .none
        return cell
    }
}
// MARK: - UITableViewDelegate
extension MyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = RealmManager.shared.read(RealmDataModel.self)[indexPath.section]
        RealmManager.shared.checkLoadMainView(display: model)
        NotificationCenter.default.post(name: Notification.Name(Constants.NotificationName.main), object: model)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == 0 ? false : true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realmData = RealmManager.shared.read(RealmDataModel.self)[indexPath.section]
            RealmManager.shared.delete(realmData)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        }
    }
}
// MARK: - Setup NavigationBar
extension MyListViewController {
    private func configNavigationBar() {
        SetupNavigation(appearance: UINavigationBarAppearance()).setup(with: self, title: .myList)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(tabBarButtonTapped))
    }
    
    @objc private func tabBarButtonTapped() {
        searchController.searchBar.becomeFirstResponder()
    }
}
// MARK: - Setup for keyboard show & hide animation(tableview height)
extension MyListViewController: KeyboardEvent {
    var transformView: UIView { return tableView }
}
// MARK: - Setup SearchBar & UISearchResultsUpdating
extension MyListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchVC = searchController.searchResultsController as! SearchLocationController
        searchVC.searchStr = searchController.searchBar.text ?? ""
    }
    
    private func setupSearchBar() {
        self.navigationItem.searchController = searchController
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchResultsUpdater = self
        
        if #available(iOS 13, *) {
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search City", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search City", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
}
// MARK: - NotificationCenter
extension MyListViewController {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationName.list), object: nil)
    }
    
    @objc func loadList(notification: NSNotification) {
        guard let coordinate = notification.object as? CLLocationCoordinate2D,
              let city = WeatherManager.shared.weatherModel else { return }
        WeatherManager.shared.getEachWeatherData(lat: coordinate.latitude, lon: coordinate.longitude, weatherVC: .listViewController) {
            RealmManager.shared.writeLocation(coordinate, cityName: city.location, mainLoad: false)
            self.tableView.reloadData()
        }
    }
}
    
    

