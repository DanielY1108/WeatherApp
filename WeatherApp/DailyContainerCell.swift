//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit

final class DailyContainerCell: UICollectionViewCell {
    
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
        collectionView.backgroundColor = .clear
        
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: "DailyCell")
        
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
        layout.scrollDirection = .vertical  // 스크롤 방향
           layout.minimumLineSpacing = 20       // 아이템의 간격
//        layout.minimumInteritemSpacing = .zero
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height/4)
    
        return layout
    }
    

}

extension DailyContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCell
        cell.backgroundColor = .green
        return cell
    }
    
    
}

extension DailyContainerCell: UICollectionViewDelegate {
    
}



// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView2: PreviewProvider {
    static var previews: some View {
        MainWeatherViewController()
            .toPreview()
    }
}
#endif
