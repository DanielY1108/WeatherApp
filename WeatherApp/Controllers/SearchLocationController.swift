//
//  SearchResultViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit
import SnapKit
import MapKit

final class SearchLocationController: UIViewController {
    
    private let tavleView = UITableView(frame: .zero)
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    var searchStr: String? {
        didSet {
            scanCity()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configTableView()
        configSearchCompleter()
        setupKeyboardEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configTableView() {
        self.view.addSubview(tavleView)
        self.tavleView.register(SearchCell.self, forCellReuseIdentifier: Constants.ID.resultID)
        self.tavleView.dataSource = self
        self.tavleView.delegate = self
        tavleView.backgroundColor = .clear
        
        tavleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Setup for keyboard show & hide animation(tableview height)
//
extension SearchLocationController: KeyboardEvent {
    var transformView: UIView { return tavleView }
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
        tavleView.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error Searchbar empty: \(error.localizedDescription)")
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
                cell.cityNameLabel.setHighlighted(for: searchResult.title, with: searchStr)
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

        search.start { response, error in
            guard error == nil else { return }
            guard let placemark = response?.mapItems[0].placemark else { return }
            print("lat: \(placemark.coordinate.latitude), lon: \(placemark.coordinate.longitude), location: \(placemark.locality)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/15
    }
}




import SwiftUI

#if DEBUG
struct PreView9: PreviewProvider {
    static var previews: some View {
        SearchLocationController()
            .toPreview()
    }
}
#endif

