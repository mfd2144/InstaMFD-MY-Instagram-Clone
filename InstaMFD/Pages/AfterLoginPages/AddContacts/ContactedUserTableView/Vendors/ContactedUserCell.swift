//
//  ContactedUserCell.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 3.08.2021.
//

import UIKit

final class ContactedUserCell:UITableViewCell{
    
    static let identifier = "ContactedUserCell"

    
    let userImage:UIImageView = {
        let imagev = UIImageView()
        imagev.layer.cornerRadius = 55
        imagev.clipsToBounds = true
        imagev.contentMode = .scaleToFill
        return imagev
    }()
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let contactLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        addSubview(userImage)
        labelStack.addArrangedSubview(userNameLabel)
        labelStack.addArrangedSubview(contactLabel)
        addSubview(labelStack)
        
        userImage.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, topDis: 5, bottomDis: -5, leadingDis: 10, trailingDis: 0, heightFloat: nil, widthFloat: 110, heightDimension: nil, widthDimension: nil)
        
        labelStack.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: userImage.trailingAnchor, trailing: nil, topDis: 30, bottomDis: -30, leadingDis: 10, trailingDis: 0, heightFloat: nil, widthFloat: 200, heightDimension: nil, widthDimension: nil)
        
        
    }
    
    func setCell(user:ContactedUserPresentation ){
        userNameLabel.text = user.userName
        contactLabel.text = user.contactNumberOrMail
        var avatarImage = UIImage(systemName: "person")
        if let urlString = user.url,let url = URL(string: urlString)  {
            appContainer.photoDownloader.downloadImage(url) { result in
                switch result{
                case.success( let image):
                    guard let image = image else {return}
                    avatarImage = image
                default:
                    break
                }
                
                DispatchQueue.main.async { [unowned self] in
                    userImage.image = avatarImage
                }
                
            }
        }
    }
    
}
