//
//  FilterPostView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import UIKit

enum FilterPostViewSections:Int,CaseIterable{
    case main
    case filteredViews
}

enum FilterPostDataItems:Hashable{
    case selected(FilteredImageContainer)
    case allFilteredImages(FilteredImageContainer)
}

final class FilterPostView:UICollectionViewController{
    
    //MARK: - Value types
    typealias DataSource = UICollectionViewDiffableDataSource<FilterPostViewSections,FilterPostDataItems>
    typealias  Snapshot = NSDiffableDataSourceSnapshot<FilterPostViewSections,FilterPostDataItems>
    
    
    //MARK: - Properties
    var viewModel:FilterPostViewModelProtocol!
    
    var mainImage:FilteredImageContainer?
    var allImages = [FilteredImageContainer]()
    lazy var dataSource = makeDataSource()
    
    lazy var nextButton :UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addImage))
        return button
    }()
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = customCollectionLayout()
        collectionView.register(PhotoCell.self,  forCellWithReuseIdentifier: PhotoCell.identifier)
       
        collectionView.backgroundColor = .black
        collectionView.delegate = self
       
        viewModel.executeFilter()
        navigationItem.rightBarButtonItem = nextButton
    }
    
    
    @objc private func addImage(){
        guard let container = mainImage?.container else {return}
        viewModel.saveImageToFirebase(container)
    }
    
    
}

extension FilterPostView{
    
    private func makeDataSource()->DataSource{
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, items in
            
            switch items{
            case .selected(let filterContainer):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell
                let image = filterContainer.container.images
                cell?.setCell(image: image!,contentMode: .scaleAspectFit)
                return cell
                
            case.allFilteredImages(let filterContainer):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell
                guard let image = filterContainer.container.images else {return UICollectionViewCell()}
            
                cell?.setCell(index: indexPath.row, delegate: self, image: image,contentMode: .scaleAspectFit)
                return cell
            }
        }
        
      
        return dataSource
    }
    
    private func applySnapShot(animatingDifferences: Bool = true){
        var snapshot = Snapshot()
        snapshot.appendSections(FilterPostViewSections.allCases)
        
        if let image = mainImage{
           let item = FilterPostDataItems.selected(image)
            snapshot.appendItems([item], toSection: FilterPostViewSections.main)
        }
        
        let allImages = allImages.map{ FilterPostDataItems.allFilteredImages($0) }
        snapshot.appendItems(allImages, toSection: FilterPostViewSections.filteredViews)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
 
    
    
    private func customCollectionLayout()->UICollectionViewCompositionalLayout{
        let composionalLayout = UICollectionViewCompositionalLayout{ section,env ->NSCollectionLayoutSection in
            
            switch section{
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let width = UIScreen.main.bounds.width
                let grpoupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(width/5*4))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: grpoupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 30, leading: 0, bottom: 100, trailing: 0)
                return section
                
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing:1)
                let width = UIScreen.main.bounds.width
                let grpoupSize = NSCollectionLayoutSize(widthDimension: .absolute(width/3), heightDimension: .absolute(width/15*4))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: grpoupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
           
                section.orthogonalScrollingBehavior = .paging
                return section
                
            default:
                fatalError()
            }
            
        }
        return composionalLayout
    }
    
}



extension FilterPostView:FilterPostViewModelDelegate{
    func handleOutputs(_ output: FilterPostViewModeloutputs) {
        switch output {
        case .isloading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case.anyErrorOccured(let caution):
            addCaution(title: "caution", message: caution)
        case .afterFilterExecuted(let containers):
            if let original = containers.filter ({$0.name == "original"}).first{
                mainImage = original
            }
            allImages = containers.sorted(by: {$0.name>$1.name})
        
           applySnapShot()
        default:
            break
        }
    
    }
    
}

extension FilterPostView:PhotoCellProtocol{
    func photoTapped(index: Int) {
        mainImage = allImages[index]
        applySnapShot()
    }
    
    
}
