//
//  CollectionViewLayout.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import UIKit

extension UICollectionViewLayout {
    
    func createMainLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            switch sectionNumber {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(100)))
                item.contentInsets.trailing = 10
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.bottom = 5
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230)), elementKind: Constants.ID.categoryHeaderID, alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                section.orthogonalScrollingBehavior = .continuous
                return section
            default:
                let itme = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)))
                itme.contentInsets.bottom = 5
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [itme])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
        return layout
    }
}
