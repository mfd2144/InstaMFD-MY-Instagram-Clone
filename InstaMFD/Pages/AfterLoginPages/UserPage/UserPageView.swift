//
//  UserPageView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 22.07.2021.
//

import UIKit

enum  UserDataItems:Hashable{
    case user(BasicUserInfo)
    case story(Story)
    case photo(Photo)
}


struct Photo:Hashable{
    let id = UUID()
    let Photo:String
    //    let date:Date
    //    let locationCode:String??
    //    let tags:[String]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct Story:Hashable{
    let photos:String
}

enum UserPageSection:Int,CaseIterable{
    case user
    case story
    case photo
    var cellIdentifier:String{
        switch self {
        case .photo:
            return "PhotoCell"
        case.story:
            return "StoryCell"
        case .user:
            return "UserCell"
        }
    }
}


final class UserPageView:UICollectionViewController{
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<UserPageSection, UserDataItems>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UserPageSection, UserDataItems>
    
    //MARK: - Properties
    
    var viewModel :UserPageViewModelProtocol!
    var user = [BasicUserInfo]()
    var photos = [Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),
                  Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),
                  Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),
                  Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),
                  Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1"),Photo(Photo: "1")]
    var stories = [Story(photos: "123"),Story(photos: "1")]
    private lazy var dataSource = makeDataSource()
    let layoutModel = UserPageCollectionViewLayout()
    
    lazy var logOutButton:UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logOut))
        return button
    }()
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = layoutModel.compositionalLayout()
        collectionView.register(UserCell.self, forCellWithReuseIdentifier:UserPageSection.user.cellIdentifier)
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: UserPageSection.story.cellIdentifier)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: UserPageSection.photo.cellIdentifier)
        collectionView.register(PhotoHeaderReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PhotoHeaderReusableView.identifier
        )
        viewModel.fetchUserInfo()
    }
    
    
    //MARK: - NavigationController
    private func setNavigationControllerproperties(){
        navigationController?.navigationBar.shadowImage = UIImage().withTintColor(.systemBackground)
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [logOutButton]
        let titleLabel = UILabel()
        titleLabel.text = user.first?.userName
        navigationController?.navigationBar.addSubview(titleLabel)
        
        titleLabel.putSubviewAt(top: navigationController?.navigationBar.topAnchor, bottom: navigationController?.navigationBar.bottomAnchor, leading: navigationController?.navigationBar.leadingAnchor, trailing: nil, topDis: 0, bottomDis: 0, leadingDis: 30, trailingDis: 0, heightFloat: 0, widthFloat: UIScreen.main.bounds.width/2, heightDimension: nil, widthDimension: nil)
    }
    
    @objc private func logOut(){
        viewModel.logOut()
    }
    
    
    //MARK: - CollectionView data source
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            
            switch item{
            //Top part
            case.user(let user):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageSection.user.cellIdentifier, for: indexPath) as? UserCell else {fatalError()}
                cell.setUpCell(delegate: self,user: user)
                return cell
                
            //middle part
            case.photo(let photo):
                guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageSection.photo.cellIdentifier, for: indexPath) as? PhotoCell else {fatalError()}
                cell.setCell(index: indexPath.row, delegate: self)
                let number = indexPath.row
                cell.backgroundColor = UIColor.init(red: CGFloat(255-((number*4)+1))/255, green:   CGFloat(255-((number*4)+1))/255, blue:   CGFloat(255-((number*4)+1))/255, alpha: 1)
                return cell
                
            //bottom part
            case.story(let story):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageSection.story.cellIdentifier, for: indexPath) as? StoryCell else {fatalError()}
                cell.cellSetUp(delegate: self, index: indexPath.row)
                return cell
            }
        }
        
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier:PhotoHeaderReusableView.identifier ,
                for: indexPath) as? PhotoHeaderReusableView
            view?.delegate = self
            return view
        }
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(UserPageSection.allCases)
        
        let userItem = user.map { UserDataItems.user($0) }
        snapshot.appendItems(userItem, toSection: UserPageSection.user)
        
        let storyItem = stories.map { UserDataItems.story($0) }
        snapshot.appendItems(storyItem, toSection: UserPageSection.story)
        
        let photoItem = photos.map { UserDataItems.photo($0) }
        snapshot.appendItems(photoItem, toSection: UserPageSection.photo)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
        
    }
}


extension UserPageView:StoryCellProtocol{
    func addButtonClicked() {
        viewModel.selectCell(.addPhotoFromAlbum)
    }
    
    func albumClicked() {
        viewModel.selectCell(.showAlbumPhoto)
    }
}

extension UserPageView:UserCellProtocol{
    func addImage() {
        viewModel.selectCell(.changeUserPhoto)
    }
}

extension UserPageView:PhotoCellProtocol{
    func photoTapped(index: Int) {
        viewModel.selectCell(.showCompletePhoto)
    }
}

extension UserPageView:PhotoHeaderReusableViewProtocol{
    func firstSegmentSelected() {
        print("first")
    }
    
    func secondSegmentSelected() {
        print("second")
    }
}

extension UserPageView:UserPageViewModelDelegate{
    func handleOutputs(_ output: UserPageViewModelOutputs) {
        switch output {
        case .showAnyAlert(let caution):
            addCaution(title: "Caution", message: caution)
        case .fetchUser(let basicUser):
            user.append(basicUser)
            setNavigationControllerproperties()
            applySnapshot()
        default:
            break
        }
    }
    
    
}
