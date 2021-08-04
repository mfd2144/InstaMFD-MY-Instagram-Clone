//
//  NewPostCell.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 27.07.2021.
//

import UIKit

final class NewPostCell:UICollectionViewCell{
    static let identifer = "NewPostCell"
    let imageView :UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    override func updateConfiguration(using state: UICellConfigurationState) {
    setImageView()
    }
    
    private func setImageView(){
        addSubview(imageView)
        imageView.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    
}
