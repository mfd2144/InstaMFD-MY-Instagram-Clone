//
//  PhotoReusableView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 24.07.2021.
//

import UIKit

protocol PhotoHeaderReusableViewProtocol:NSObject{
    func firstSegmentSelected()
    func secondSegmentSelected()
}

class PhotoHeaderReusableView: UICollectionReusableView {
    static let identifier = "PhotoReusableHeader"
    
    weak var delegate:PhotoHeaderReusableViewProtocol?
    let segmentController: CustomSegmentController = {
        let image1 = UIImage(systemName: "squareshape.split.3x3")
        let image2 = UIImage(systemName: "rectangle.stack.person.crop")
        let segment = CustomSegmentController(firsImage: image1!, secondImage: image2!)
//        let segment = CustomSegmentController(firstSegment: "bir", SecondSegment: "iki")
        return segment
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
     addSubview(segmentController)
        segmentController.delegate = self
        segmentController.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension PhotoHeaderReusableView:CustomSegmentControllerDelegate{
    func firsSegmentSelected() {
        delegate?.firstSegmentSelected()
    }
    
    func secondSegmentSelected() {
        delegate?.secondSegmentSelected()
    }
    
    
}
