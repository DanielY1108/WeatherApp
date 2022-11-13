//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit


final class MainWeatherViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
         
        configureCollectionView()
    }
    
    
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = true   //스크롤 활성화
        //        collectionView.showsHorizontalScrollIndicator = false  // 가로 방향 스크롤모양 활성화
        collectionView.showsVerticalScrollIndicator = true     // 세로 방향 스크롤모양 활성화
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        
        collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainHeaderView")
        collectionView.register(DailyContainerCell.self, forCellWithReuseIdentifier: "DailyContainerCell")
        collectionView.register(HourlyContainerCell.self, forCellWithReuseIdentifier: "HourlyContainerCell")
        
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    
    func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical  // 스크롤 방향
        layout.minimumLineSpacing = .zero
        layout.itemSize = CGSize(width: view.bounds.width,
                                 height: view.bounds.height/3)
        layout.headerReferenceSize = CGSize(width: view.bounds.width,
                                            height: view.bounds.height/3)
        
        
        return layout
    }
    
    
}


// MARK: - UICollectionViewDataSource

extension MainWeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyContainerCell", for: indexPath) as! HourlyContainerCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyContainerCell", for: indexPath) as! DailyContainerCell
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainHeaderView", for: indexPath) as! MainHeaderView
        return header
    }
    
}





// MARK: - UICollectionViewDelegate

extension MainWeatherViewController: UICollectionViewDelegate  {
    
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



