//
//  PhotoCell.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 24.07.2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    weak var delegate:PhotoCellProtocol?
    var index:Int?
    static let identifier = "PhotoCell"
    private let imageView :UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
        addSubview(imageView)
        imageView.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    func setCell(image:UIImage,contentMode:UIImageView.ContentMode){
        imageView.image = image
        imageView.contentMode = contentMode
    }
    
    
    func setCell(index:Int,delegate:PhotoCellProtocol,image:UIImage,contentMode:UIImageView.ContentMode){
        self.delegate = delegate
        self.index = index
        imageView.image = image
        imageView.contentMode = contentMode
        
    }
    
    @objc private func cellTapped(){
        guard let index = index else {return}
        delegate?.photoTapped(index: index)
    }
}

protocol  PhotoCellProtocol:AnyObject {
    func photoTapped(index:Int)
}
