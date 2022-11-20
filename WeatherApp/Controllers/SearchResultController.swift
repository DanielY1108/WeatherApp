//
//  SearchResultViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/20.
//

import UIKit
import SnapKit

class SearchResultController: UIViewController {
    
    private let tavleView = UITableView(frame: .zero)
    private let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    func configTableView() {
        self.view.addSubview(tavleView)
        self.tavleView.register(SearchResultCell.self, forCellReuseIdentifier: Constants.ID.resultID)
        self.tavleView.dataSource = self
        self.tavleView.delegate = self
        view.backgroundColor = .lightGray
        tavleView.backgroundColor = .clear
        
        tavleView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
}

extension SearchResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.resultID, for: indexPath) as! SearchResultCell
        return cell
    }
    
    
}

extension SearchResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}




import SwiftUI

#if DEBUG
struct PreView9: PreviewProvider {
    static var previews: some View {
        SearchResultController()
            .toPreview()
    }
}
#endif

