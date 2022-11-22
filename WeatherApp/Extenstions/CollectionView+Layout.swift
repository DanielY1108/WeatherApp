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
            // section 1
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(100)))
                item.contentInsets.trailing = 10
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.bottom = 5
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230)), elementKind: Constants.ID.categoryHeaderID, alignment: .top)
                
//                sectionHeader.pinToVisibleBounds = true
                
                section.boundarySupplementaryItems = [sectionHeader]
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            } else {
                // section 2
                let itme = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
                itme.contentInsets.bottom = 5
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [itme])
                
                let section = NSCollectionLayoutSection(group: group)
                                
                return section
            }
        }
        return layout
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}


// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView6: PreviewProvider {
    static var previews: some View {
        MyListViewController()
            .toPreview()
    }
}
#endif
