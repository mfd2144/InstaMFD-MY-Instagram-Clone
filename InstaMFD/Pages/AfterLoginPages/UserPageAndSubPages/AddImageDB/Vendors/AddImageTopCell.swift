//
//  AddImageTopCell.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import UIKit

let addImagePlaceHolder = "Write a caption..."
final class AddImageTopCell:UITableViewCell{
    static let identifier = "AddImageTopCell"
    
    let selectedImage:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    let textView:UITextView = {
        let view  = UITextView()
        view.text = addImagePlaceHolder
        view.backgroundColor = .white
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .lightGray
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    setSubviews()
        setSubviews()
        
    }
    
    
    private func setSubviews(){
        addSubview(selectedImage)
        addSubview(textView)
        selectedImage.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, topDis: 10, bottomDis: -10, leadingDis: 10, trailingDis: 0, heightFloat: 100, widthFloat: 100, heightDimension: nil, widthDimension: nil)
        textView.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: selectedImage.trailingAnchor, trailing: trailingAnchor, topDis: 10, bottomDis: -10, leadingDis: 20, trailingDis: -10, heightFloat: 100, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    
    func setCell(delegate:UITextViewDelegate, image:UIImage){
        selectedImage.image = image
        textView.delegate = delegate
    }
}

