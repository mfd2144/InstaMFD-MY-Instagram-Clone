//
//  CustomSegment.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import UIKit
import Combine


protocol CustomSegmentControllerDelegate:AnyObject{
    func firsSegmentSelected()
    func secondSegmentSelected()
}

final class CustomSegmentController:UIView{
    weak var delegate:CustomSegmentControllerDelegate?
    
    private let selectedSegment = CurrentValueSubject<Int,Never>(0)
    private var subscriptions = Set<AnyCancellable>()
    private var secondSegmentTapGesture:UITapGestureRecognizer!
    private var firstSegmentTapGesture:UITapGestureRecognizer!
    private var firstSegment:String?
    private var secondSegment:String?
    
    private var firsImage:UIImage?
    private var secondImage:UIImage?
    
    private var firstImageGray:UIImage?{
        get{
            firsImage?.withTintColor(.gray)
        }
    }
    private var secondImageGray:UIImage?{
        get{
            secondImage?.withTintColor(.gray)
        }
    }
    
    var selectedIndex:Int{
        get{
            return selectedSegment.value
        }
    }
    
    convenience init(firstSegment:String,SecondSegment:String){
        self.init(frame: .zero)
        self.firstSegment = firstSegment
        self.secondSegment = SecondSegment
        setSegment()
    }
    
    convenience init(firsImage:UIImage,secondImage:UIImage){
        self.init(frame: .zero)
        self.firsImage = firsImage.withRenderingMode(.alwaysOriginal)
        self.secondImage = secondImage.withRenderingMode(.alwaysOriginal)
        setSegmentImage()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSegment(){
        labelfirstSegment.text = firstSegment != nil ? firstSegment : "first"
        labelsecondSegment.text = secondSegment != nil ? secondSegment : "second"
        addSubviews()
        addGestures()
        listener()

    }

    private func setSegmentImage(){
        addSubviews()
        addGestures()
        listener()

    }
    
    
    private let customSegmenStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    private let stackLeft:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()
    
    private let stackRight:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()
    
    private var labelfirstSegment:UILabel = {
        let label = UILabel()
        label.text = "first"
        label.textAlignment = .center
        label.textColor = .none
        return label
    }()
    
    private let labelsecondSegment:UILabel = {
        let label = UILabel()
        label.text = "second"
        label.textAlignment = .center
        label.textColor = .none
        return label
    }()
    private let line1:UIImageView = {
        let imageV = UIImageView()
        imageV.layer.borderWidth = 2
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return imageV
    }()
    
    private let line2:UIImageView = {
        let imageV = UIImageView()
        imageV.layer.borderWidth = 2
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return imageV
    }()
    
    private let image1:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    private let image2:UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    
    private func addSubviews(){
    
        if firsImage != nil || secondImage != nil {
            image1.image = firsImage
            image2.image = secondImage
            stackRight.addArrangedSubview(image2)
            stackLeft.addArrangedSubview(image1)
        }else{
            stackRight.addArrangedSubview(labelsecondSegment)
            stackLeft.addArrangedSubview(labelfirstSegment)
        }
       
        stackLeft.addArrangedSubview(line1)
        stackRight.addArrangedSubview(line2)
        customSegmenStack.addArrangedSubview(stackLeft)
        customSegmenStack.addArrangedSubview(stackRight)
        addSubview(customSegmenStack)
        customSegmenStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customSegmenStack.topAnchor.constraint(equalTo: topAnchor),
            customSegmenStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            customSegmenStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            customSegmenStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func addGestures(){
        secondSegmentTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondSegmentTapped))
        firstSegmentTapGesture = UITapGestureRecognizer(target: self, action:#selector(firstSegmentTapped))
        
        if firsImage != nil || secondImage != nil{
            image1.addGestureRecognizer(firstSegmentTapGesture)
            image2.addGestureRecognizer(secondSegmentTapGesture)
            image1.isUserInteractionEnabled = true
            image2.isUserInteractionEnabled = true
        }else{
            labelsecondSegment.addGestureRecognizer(secondSegmentTapGesture)
            labelsecondSegment.isUserInteractionEnabled = true
            labelfirstSegment.addGestureRecognizer(firstSegmentTapGesture)
            labelfirstSegment.isUserInteractionEnabled = true
        }

    }
    
    @objc private func firstSegmentTapped(){
        selectedSegment.send(0)
    }
    
    @objc private func secondSegmentTapped(){
        selectedSegment.send(1)
    }
    
    fileprivate func firstSegmentSelected() {
        
        if firsImage != nil || secondImage != nil {
            image1.image = firsImage
            image2.image = secondImageGray
        }else {
            labelfirstSegment.textColor = .none
            labelsecondSegment.textColor = .gray
        }
        line1.layer.borderColor = UIColor.black.cgColor
        line2.layer.borderColor = UIColor.gray.cgColor
        firstSegmentTapGesture.isEnabled = false
        secondSegmentTapGesture.isEnabled = true
        delegate?.firsSegmentSelected()
    }
    
    fileprivate func secondSegmentSelected() {
        
        if firsImage != nil || secondImage != nil {
            image1.image = firstImageGray
            image2.image = secondImage
        }else {
        labelfirstSegment.textColor = .gray
        labelsecondSegment.textColor = .none
        }
        
        line1.layer.borderColor = UIColor.gray.cgColor
        line2.layer.borderColor = UIColor.black.cgColor
        firstSegmentTapGesture.isEnabled = true
        secondSegmentTapGesture.isEnabled = false
        delegate?.secondSegmentSelected()
    }
    
    fileprivate func listener() {
        // listen to labels and textFields
        
        selectedSegment.sink {[unowned self] segmentIndex in
            if segmentIndex == 0{
                firstSegmentSelected()
            }else{
                secondSegmentSelected()
            }
        }.store(in: &subscriptions)
        
    }
    
}


