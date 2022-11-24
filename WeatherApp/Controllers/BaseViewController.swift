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
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // 콜렉션뷰
    private func configureCollectionView() {        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(weatherHeader.self, forSupplementaryViewOfKind: Constants.ID.categoryHeaderID, withReuseIdentifier: Constants.ID.headerID)
        
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: Constants.ID.dailyID)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: Constants.ID.hourlyID)
    }
    
    // 레이아웃 및 서브뷰 관리
    func configUI() {
        self.view.addSubview(backgroundView)
        self.backgroundView.addSubview(collectionView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(80)
            make.bottom.equalTo(backgroundView).inset(80)
            make.leading.equalTo(backgroundView).inset(25)
            make.trailing.equalTo(backgroundView).inset(25)
        }
        
    }
    
}



// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView10: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif



