//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    let backgroundView = BackgroundView()
    private let customLayout = UICollectionViewLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout.createMainLayout())
    
    let licenses: [License] = [
        License(.weatherKit),
        License(.openWeather)
    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(80)
            make.bottom.equalTo(backgroundView).inset(40)
            make.leading.equalTo(backgroundView).inset(20)
            make.trailing.equalTo(backgroundView).inset(20)
        }
    }
    
    func configureUI() {
        self.view.addSubview(backgroundView)
        self.backgroundView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(weatherHeader.self, forSupplementaryViewOfKind: Constants.ID.categoryHeaderID, withReuseIdentifier: Constants.ID.headerID)
        collectionView.register(LicenseFooter.self, forSupplementaryViewOfKind: Constants.ID.categoryFooterID, withReuseIdentifier: Constants.ID.footerID)
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: Constants.ID.dailyID)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: Constants.ID.hourlyID)
    }
}




