//
//  SearchResultViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

final class SearchLocationController: UIViewController {
        
    private let tableView = UITableView(frame: .zero)
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    var searchStr: String? {
        didSet {
            scanCity()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureUI()
        configSearchCompleter()
        setupKeyboardEvent()
        setupLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
    }
    
    private func configureUI() {
        self.view.addSubview(tableView)
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: Constants.ID.resultID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - UITableViewDataSource
extension SearchLocationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.resultID, for: indexPath) as! SearchCell
        let searchResult = searchResults[indexPath.row]
        
        DispatchQueue.main.async {
            if let searchStr = self.searchStr {
                cell.cityNameLabel.setHighlighted(searchResult.title, with: searchStr)
            }
            cell.countyNameLabel.text = searchResult.subtitle
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension SearchLocationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard error == nil else { return }
            
            guard let coordinate = response?.mapItems[0].placemark.coordinate else { return }
            
            let subVC = SubWeatherController()
            subVC.getLocationFromSearch = coordinate
            self?.present(subVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/17
    }
}
// MARK: - MKLocalSearchCompleter
extension SearchLocationController {
    private func configSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    private func scanCity() {
        guard let search = searchStr?.lowercased() else { return }
        searchCompleter.queryFragment = search
    }
}
// MARK: - MKLocalSearchCompleterDelegate
extension SearchLocationController: MKLocalSearchCompleterDelegate {
    // 자동완성 완료시 결과를 받는 함수
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // completer.results를 통해 검색한 결과를 searchResults에 담아줍니다
        searchResults = completer.results
        tableView.reloadData()
        
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
// MARK: - Setup for keyboard show & hide animation(tableview height)
extension SearchLocationController: KeyboardEvent {
    var transformView: UIView { return tableView }
}
