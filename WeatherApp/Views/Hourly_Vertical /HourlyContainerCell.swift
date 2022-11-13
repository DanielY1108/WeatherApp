//
//  HoulyContainerCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit

final class HourlyContainerCell: UICollectionViewCell {
    
    private var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = true   //스크롤 활성화
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
        
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
    
    func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal  // 스크롤 방향
        layout.minimumLineSpacing = 20       // 아이템의 간격
        layout.minimumInteritemSpacing = self.bounds.height
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 100, height: 150)
        
        return layout
    }
    
    
}

extension HourlyContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
        cell.backgroundColor = .brown
        return cell
    }
    
    
}

extension HourlyContainerCell: UICollectionViewDelegate {
    
}


// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView1: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif
