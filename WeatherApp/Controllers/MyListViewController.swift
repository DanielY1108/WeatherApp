//
//  MyListController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit
import SnapKit
import RealmSwift

final class MyListViewController: UIViewController {
  
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let searchController = UISearchController(searchResultsController: SearchLocationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        setupSearchBar()
        configUI()
        configTableView()
        setupKeyboardEvent()
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyListCell.self, forCellReuseIdentifier: Constants.ID.myListID)
    }
    
    private func configUI() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

// MARK: - NotificationCenter

extension MyListViewController {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification) {
        self.tableView.reloadData()
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
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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



// MARK: - Setup for keyboard show & hide animation(tableview height)
//
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

