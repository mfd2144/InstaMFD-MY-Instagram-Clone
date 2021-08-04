//
//  NewPostView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 27.07.2021.
//

import UIKit
import Photos



final class NewPostView:UIViewController{
    
    //MARK: - Value types
    typealias DataSource = UICollectionViewDiffableDataSource<NewPostSection,ImageContainer>
    typealias SnapShot = NSDiffableDataSourceSnapshot<NewPostSection,ImageContainer>
    

    //MARK: - Properties
    
    var imageArray = Array<ImageContainer>()
    var viewModel:NewPostViewModelProtocol!
    lazy var dataSource = makeDataSource()
    var selectedContainer :ImageContainer?
    
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
//        scroll.minimumZoomScale = 1
//        scroll.maximumZoomScale = 3
//        scroll.backgroundColor = .black
//        scroll.bounces = true
//        scroll.bouncesZoom = true
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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAlbumPhotos()
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
        navigationItem.hidesBackButton = true
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
    
    @objc private func albumLabelPressed(){
        viewModel.selectAlbum()
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
   
    
    @objc private func cancelPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextPressed(){
        guard let container = selectedContainer else {return}
        viewModel.showPhoto(container)
    }
    
    
}
extension NewPostView:UICollectionViewDelegate{
    
    private func makeDataSource()->DataSource{

        let dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, imageContainer in
            
            if indexPath.row == imageArray.count - 100{
                viewModel.getAlbumPhotos()
            }
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPostCell.identifer, for: indexPath) as? NewPostCell
            cell?.imageView.image = imageContainer.images
            return cell
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = SnapShot()
        snapshot.appendSections(NewPostSection.allCases)
        snapshot.appendItems(imageArray, toSection: NewPostSection.main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedContainer = imageArray[indexPath.row]
        imageView.image = selectedContainer?.images
        print(selectedContainer?.images?.configuration)
//        let size = CGSize(width: (image?.size.width)!, height: (image?.size.width)!)
//        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
//        scrollView.contentSize = image!.size
//        scrollView.autoresizingMask = .flexibleWidth
        
    }
    
    }
 

extension NewPostView:NewPostViewModelDelegate{
    func handleOutput(_ output: NewPostViewModelOutputs) {
        
        
        switch output {
        case .anyCaution(let caution):
            addCaution(title: "caution", message: caution)
        //todo
        break
        case.isLoading(let loading):
           
            loading ? Animator.sharedInstance.showAnimation():Animator.sharedInstance.hideAnimation()
            
        case .photos(let array):
            imageArray = array
                selectedContainer = imageArray[0]
            DispatchQueue.main.async { [unowned self] in
                imageView.image = selectedContainer?.images
                applySnapshot()
        }
        case .setAlbumNAme(let name):
            albumNameLabel.text = name
        }
    }
}



extension NewPostView:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension NewPostView{

func crop() {//todo
    let scale:CGFloat = imageScroll.frame.height/imageScroll.contentSize.height
    let image = imageView.image
    let x:CGFloat = imageScroll.contentOffset.x*scale
    let y:CGFloat = imageScroll.contentOffset.y*scale
    let width:CGFloat = (image?.size.width)! * scale
    let height:CGFloat = (image?.size.height)! * scale
    

   
    let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
    let croppedImage = UIImage(cgImage: croppedCGImage!)
    imageView.image = croppedImage
}

}
