//
//  MyListController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/19.
//

import UIKit
import SnapKit

class MyListViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout.createListLayout())
    private let layout = UICollectionViewLayout()
    private let searchController = UISearchController(searchResultsController: SearchResultController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        setupSearchBar()
        configUI()
        configCollectionView()
    }
    
    func configCollectionView() {
        collectionView.dataSource = self
        
        collectionView.register(MyListCell.self, forCellWithReuseIdentifier: Constants.ID.myListID)
    }
    
    func configUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}

extension MyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ID.myListID, for: indexPath) as! MyListCell
        cell.layer.cornerRadius = 20
        return cell
    }
}

// MARK: - Setup SearchBar & UISearchResultsUpdating
extension MyListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchVC = searchController.searchResultsController as! SearchResultController
        searchVC.searchStr = searchController.searchBar.text ?? ""
    }
    
    func setupSearchBar() {
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search City"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchResultsUpdater = self
    }
}

// MARK: - Setup NavigationBar
extension MyListViewController {
    func configNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18.0),
                                          .foregroundColor: UIColor.systemGreen]
        // 기본 설정 (standard, compact, scrollEdge)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.title = "My List"
        self.navigationController?.navigationBar.tintColor = .red  // 틴트색상 설정
                self.navigationItem.hidesSearchBarWhenScrolling = false  // 검색창 항상 위
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(tabBarButtonTapped))
    }
    
    @objc func tabBarButtonTapped() {
        
    }
}



import SwiftUI

#if DEBUG
struct PreView7: PreviewProvider {
    static var previews: some View {
        MyListViewController()
            .toPreview()
    }
}
#endif
