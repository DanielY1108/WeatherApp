//
//  ViewController.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/13.
//

import UIKit


final class MainWeatherViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    let net = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureCollectionView()
        net.fetchWeather(cityName: "seoul")
    }
    
    
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createlLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        collectionView.register(MainWeatherHeader.self, forSupplementaryViewOfKind: self.categoryHeaderID, withReuseIdentifier: headerId)
        
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: "DailyCell")
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: "HourlyCell")
        
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func createlLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(160)))
                item.contentInsets.trailing = 10
                item.contentInsets.bottom = 15
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 20
                section.contentInsets.trailing = 20

                // header, footer 등등 만드는 배열
                let secionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250)), elementKind: self.categoryHeaderID, alignment: .topLeading)
                section.boundarySupplementaryItems = [secionHeader]
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            } else {
                
                let itme = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)))
                itme.contentInsets.bottom = 10
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [itme])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets.leading = 20
                section.contentInsets.trailing = 20
                
                return section
            }
        }
        return layout
    }
    
    let categoryHeaderID = "categoryHeaderID"
    let headerId = "headerId"
    
}


// MARK: - UICollectionViewDataSource

extension MainWeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 8
        default:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
            cell.backgroundColor = .blue
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCell
            cell.backgroundColor = .blue
            return cell
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MainWeatherHeader
        return header
    }
    
}







// MARK: - UICollectionViewDelegate

extension MainWeatherViewController: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller =  UIViewController()
        controller.view.backgroundColor = indexPath.section == 0 ? .yellow : .red
        present(controller, animated: true)
    }
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



