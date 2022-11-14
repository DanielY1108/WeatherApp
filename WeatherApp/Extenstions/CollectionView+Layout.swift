//
//  CollectionViewLayout.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import UIKit

extension UICollectionViewLayout {
    
    func createlLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            
            // section 1
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(160)))
                item.contentInsets.trailing = 10
                item.contentInsets.bottom = 15
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 20
                section.contentInsets.trailing = 20
                
                let secionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250)), elementKind: Constants.ID.categoryHeaderID, alignment: .topLeading)
                section.boundarySupplementaryItems = [secionHeader]
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            } else {
                // section 2
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
}

