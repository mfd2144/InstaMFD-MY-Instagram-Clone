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
    override func updateConfiguration(using state: UICellConfigurationState) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func setCell(index:Int,delegate:PhotoCellProtocol){
        self.delegate = delegate
        self.index = index
    }
    
    @objc private func cellTapped(){
        guard let index = index else {return}
        delegate?.photoTapped(index: index)
    }
}

protocol  PhotoCellProtocol:AnyObject {
    func photoTapped(index:Int)
}
