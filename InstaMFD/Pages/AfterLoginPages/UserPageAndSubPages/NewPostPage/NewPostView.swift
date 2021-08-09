//
//  NewPostView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 27.07.2021.
//

import UIKit
import Photos



func runInMain(block: @escaping () -> Void) -> Void {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}


final class NewPostView:UIViewController{
    
    //MARK: - Value types
    typealias DataSource = UICollectionViewDiffableDataSource<NewPostSection,PHAsset>
    typealias SnapShot = NSDiffableDataSourceSnapshot<NewPostSection,PHAsset>
    
    
    //MARK: - Properties
    
    var album:AlbumCollection?{
        didSet{
            var assets = [PHAsset]()
            album?.collection.fetchAssets(block: { fetchResults in
                fetchResults.enumerateObjects({[unowned self] pHAsset, Int, info in
                    assets.append(pHAsset)
                    if  fetchResults.count == assets.count{
                        allAsset = assets
                        loadImage(index: 0)
                        runInMain {
                            albumNameLabel.text = album?.name
                        }

                        applySnapshot()
                    }
                })
                
            })
        }
    }
    
    
    fileprivate var allAsset = [PHAsset]()
    
    var viewModel:NewPostViewModelProtocol!
    lazy var dataSource = makeDataSource()
    var actualTypeRawValue:Int?
    
    
    //MARK: - View Porperties
    let scrollView:UIScrollView = {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+UIScreen.main.bounds.width-200)
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.contentSize = size
        scroll.backgroundColor = .black
        scroll.showsVerticalScrollIndicator = false
        scroll.bouncesZoom = true
        return scroll
    }()
    
    let collectionView :UICollectionView = {
        let width = UIScreen.main.bounds.width
        let totalHeight = UIScreen.main.bounds.height+UIScreen.main.bounds.width-200
        let collectionTop = width/4*3+60
        let view = UICollectionView(frame:CGRect(x:0 , y: collectionTop, width: width, height: totalHeight-collectionTop), collectionViewLayout: UICollectionViewLayout())
        view.backgroundColor = .black
        return view
    }()
    
    let imageScroll:UIScrollView = {
        let width = UIScreen.main.bounds.width
        let size = CGSize(width:width , height:width/4*3 )
        let scroll = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    
    let imageView: UIImageView = {
        let width = UIScreen.main.bounds.width
        let size = CGSize(width:width , height:width/4*3  )
        let imageV = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    let middleStack: UIStackView = {
        let width = UIScreen.main.bounds.width
        let view = UIStackView(frame: CGRect(x: 0, y: width/4*3 , width: width/3, height: 60))
        view.backgroundColor = .black
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0
        
        view.distribution = .fillEqually
        return view
    }()
    
    let albumNameLabel:UILabel = {
        let label = UILabel()
        label.text = "Recents"
        label.textColor = .white
        return label
    }()
    
    let triangleImage:UIImageView = {
        let imagev = UIImageView(image: .init(systemName: "arrowtriangle.down")?.withRenderingMode(.alwaysOriginal).applyingSymbolConfiguration(.init(weight: .ultraLight))?.withTintColor(.white))
        imagev.contentMode = .center
        return imagev
    }()
    
    
    lazy var cancelButton :UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        button.tintColor = .white
        return button
    }()
    
    lazy var nextButton :UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
        button.tintColor = .systemTeal
        return button
    }()
    
    
    
    
    //MARK: - Life cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAlbumPhotos()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setCollectionView()
        setGesture()
        setNavBar()
        imageView.isUserInteractionEnabled = true
        imageScroll.delegate = self
        collectionView.delegate = self
    }
    
    
    //MARK: - Set subviews
    private func setSubviews(){
        middleStack.addArrangedSubview(albumNameLabel)
        middleStack.addArrangedSubview(triangleImage)
        imageScroll.addSubview(imageView)
        scrollView.addSubview(imageScroll)
        scrollView.addSubview(middleStack)
        scrollView.addSubview(collectionView)
        view.addSubview(scrollView)
        
        
    }
    
    private func setNavBar(){
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
        navigationItem.title = "New Post"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        
    }
    
    private func setCollectionView(){
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(NewPostCell.self, forCellWithReuseIdentifier: NewPostCell.identifer)
        applySnapshot(animatingDifferences: true)
    }
    
    //MARK: - Add Gesture
    
    private func setGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(albumLabelPressed))
        albumNameLabel.addGestureRecognizer(gesture)
        albumNameLabel.isUserInteractionEnabled = true
    }
  
    
    
    //MARK: - Methods
    private func createLayout()->UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _,_ ->NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize:itemSize )
            item.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.25))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem:item,count: 4)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            return section
            
        })
        return layout
    }
    
    
    @objc private func albumLabelPressed(){
        viewModel.selectAlbum()
    }
    
    @objc private func cancelPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextPressed(){
        let image = imageView.image
        let container = ImageContainer(images:image , info: nil)
        viewModel.nextPage(container)
    }
    
   private func setImageFor(cell: NewPostCell, for indexPath: IndexPath) -> Void {
        let asset = allAsset[indexPath.row]
        let _ = asset.requestImage(size: CGSize.init(width: 90.0, height: 90.0)) { (dic) in
            let image: UIImage? = dic[AlbumConstant.ImageKey] as? UIImage
            runInMain {
                if cell.localIdentifier == asset.localIdentifier {
                    cell.imageView.image = image
                    if image == nil && asset.mediaType == .video {
                        cell.imageView.image = UIImage(named:"Video")
                    }
                } else {
                    Debug.AlbumDebug("\(indexPath.section),\(indexPath.row)")
                }
            }
        }
    }
    
    private func loadImage(index:Int){
         let asset = allAsset[index]
        let _ = asset.requestImage(size: CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight)) { (dic) in
            let image: UIImage? = dic[AlbumConstant.ImageKey] as? UIImage
            runInMain {[unowned self] in
                imageView.image = image
            }
        }

    }
    
}



extension NewPostView:UICollectionViewDelegate{
    
    private func makeDataSource()->DataSource{
        
        let dataSource = DataSource(collectionView: collectionView) {[unowned self]collectionView, indexPath, asset in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPostCell.identifer, for: indexPath) as? NewPostCell
            
            cell?.localIdentifier = asset.localIdentifier
            if let cell = cell{
                setImageFor(cell: cell, for: indexPath)
            }
            return cell
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = SnapShot()
        snapshot.appendSections(NewPostSection.allCases)
        
        snapshot.appendItems(allAsset,toSection: NewPostSection.main)
        runInMain {[unowned self] in
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadImage(index: indexPath.row)
    }
    
}


extension NewPostView:NewPostViewModelDelegate{
    func handleOutput(_ output: NewPostViewModelOutputs) {
        switch output {
        case .anyCaution(let caution):
            var cautionView:AddAnySimpleCaution?
            DispatchQueue.main.async {
                cautionView = AddAnySimpleCaution.init(title: "Caution", message: caution)
                self.present(cautionView!, animated: true, completion: nil)
            }
            
        case.isLoading(let loading):
            
            if loading {Animator.sharedInstance.showAnimation()
                
            } else{
                Animator.sharedInstance.hideAnimation()
            }
            
        case .setAlbumNAme(let name):
            albumNameLabel.text = name
        case .loadAlbum(let _album):
            album = _album
            
        }
    }
}



extension NewPostView:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
