//
//  File.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 24.07.2021.
//

import UIKit
struct UserPageCollectionViewLayout{
    func compositionalLayout()->UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { (section,env) -> NSCollectionLayoutSection? in
            switch section{
            case 0:
                return sectionTop()
            case 1:
                return sectionStory()
            default:
                return sectionPhoto()
            }
        }

        return layout
    }
    
    private func sectionTop()->NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let inset = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5)
        item.contentInsets = inset
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group:group )
        return section
        
    }
    
    private func sectionStory()->NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension:.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let inset = NSDirectionalEdgeInsets.init(top: 8  , leading: 8, bottom: 8, trailing: 8)
        item.contentInsets = inset
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
        let section = NSCollectionLayoutSection(group:group )
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 0, leading: 0, bottom: 30, trailing: 0)
        return section
        
    }
    
    private func sectionPhoto()->NSCollectionLayoutSection{
       let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension:.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let inset = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5)
        item.contentInsets = inset
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item,item,item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
            elementKind:UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        let section = NSCollectionLayoutSection(group:group )
        section.boundarySupplementaryItems = [sectionHeader]
    
        return section
    }
}



