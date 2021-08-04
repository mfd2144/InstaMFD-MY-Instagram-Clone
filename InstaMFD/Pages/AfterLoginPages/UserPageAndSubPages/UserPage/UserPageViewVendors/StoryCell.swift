//
//  StoryCell.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 24.07.2021.
//

import UIKit

class StoryCell: UICollectionViewCell {
    weak var delegate:StoryCellProtocol?
    lazy var imageView :UIImageView = {
        let imageV = UIImageView()
        imageV.backgroundColor = .clear
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageV.image = image
        return imageV
    }()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
       layer.cornerRadius = frame.height/2
        backgroundColor = .gray

       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func cellSetUp(delegate:StoryCellProtocol,index:Int){
        self.delegate = delegate
        setsubview(index)
      
    }
    
    
    
    private func setsubview(_ index:Int){
        if index == 0{
           addSubview(imageView)
            imageView.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
            let tap = UITapGestureRecognizer(target: self, action: #selector(addTapped(_:)))
            addGestureRecognizer(tap)
        }else{
            imageView.removeFromSuperview()
            let tap = UITapGestureRecognizer(target: self, action: #selector(albumTapped(_:)))
            addGestureRecognizer(tap)
        }
    }
    
    @objc private func addTapped(_ gesture:UIGestureRecognizer){
        delegate?.addButtonClicked()
    }
    
    @objc private func albumTapped(_ gesture:UIGestureRecognizer){
        delegate?.albumClicked()
    }
}

protocol StoryCellProtocol:AnyObject{
    func addButtonClicked()
    func albumClicked()
}
