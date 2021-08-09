//
//  UserCell.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 23.07.2021.
//

import UIKit

class UserCell: UICollectionViewCell {
    private var user:BasicUserInfo?
    let size = UIScreen.main.bounds.width/2-10
    weak var delegate: UserCellProtocol?
    private let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.layer.borderWidth = 4
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        imageV.layer.borderColor = UIColor.systemTeal.cgColor
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    private let addImage: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageV.contentMode = .center
        imageV.image = image
        imageV.backgroundColor = .systemTeal
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = imageV.frame.height/2
        imageV.layer.borderColor = UIColor.white.cgColor
        
        
        imageV.layer.borderWidth = 1
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    
    
    private let stackMain: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        return stack
    }()
    
    private let stackPost: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    private let constLabelPost: UILabel = {
        let label = UILabel()
        label.text = "Posts"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let constLabelFollowers: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let constLabelFollowing: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private let labelPost: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    private let labelFollowers: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textAlignment = .center
        return label
    }()
    
    private let labelFollowing: UILabel = {
        let label = UILabel()
        label.text = "23"
        label.textAlignment = .center
        return label
    }()
    
    private let stackFollowers: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let stackFollowing: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setView()
        setTap()
    }
    
    //MARK: - Cell subviews
    private func setView(){
        stackPost.addArrangedSubview(labelPost)
        stackPost.addArrangedSubview(constLabelPost)
        stackFollowers.addArrangedSubview(labelFollowers)
        stackFollowers.addArrangedSubview(constLabelFollowers)
        stackFollowing.addArrangedSubview(labelFollowing)
        stackFollowing.addArrangedSubview(constLabelFollowing)
        stackMain.addArrangedSubview(stackPost)
        stackMain.addArrangedSubview(stackFollowers)
        stackMain.addArrangedSubview(stackFollowing)
        
        addSubview(stackMain)
        addSubview(imageView)
        addSubview(addImage)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            addImage.heightAnchor.constraint(equalToConstant: 20),
            addImage.widthAnchor.constraint(equalToConstant: 20),
            addImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor,constant: size/8 + 10),
            addImage.centerYAnchor.constraint(equalTo: imageView.centerYAnchor,constant: size/8 + 10)
        ])
        
        
        stackMain.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: imageView.trailingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
        imageView.layer.cornerRadius = size/4
        
    }
    
    //MARK: - Set cell properties
    
    func setUpCell(delegate:UserCellProtocol,user:BasicUserInfo){
        self.delegate = delegate
        self.user = user
        setCellSubviews()
    }
    
    private func setCellSubviews(){
        guard let user = user else {return}
        labelFollowers.text = String(user.followers)
        labelFollowing.text = String(user.following)
        labelPost.text = String(user.posts)
        var avatarImage = UIImage(systemName: "person")

        if let urlString = user.userImage,let url = URL(string: urlString)  {
            appContainer.photoDownloader.downloadImage(url) { result in
                switch result{
                case.success( let image):
                    guard let image = image else {return}
                    let data = image.pngData()
                    UserDefaults.standard.setValue(data, forKey: "userImageData")
                    avatarImage = image
                default:
                    break
                }
                DispatchQueue.main.async {
                    if let imageData = UserDefaults.standard.data(forKey: "userImageData"){
                        let image = UIImage(data: imageData)
                        self.imageView.image = image
                    }else{
                        self.imageView.image = avatarImage
                    }
                    
                  
                }
                
            }
        }
    }
    
    //MARK: - Set cell tap
    private func setTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(addButtonTapped) )
        addImage.addGestureRecognizer(tapGesture)
        addImage.isUserInteractionEnabled = true
    }
    
    @objc func addButtonTapped(){
        delegate?.addImage()
    }
}

protocol UserCellProtocol:AnyObject{
    func addImage()
}





