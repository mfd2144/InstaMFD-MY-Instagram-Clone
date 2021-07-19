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
    var firstSegment:String?
    var secondSegment:String?
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addGestures()
        listener()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSegment(){
        labelfirstSegment.text = firstSegment != nil ? firstSegment : "first"
        labelsecondSegment.text = secondSegment != nil ? secondSegment : "second"
    }

    
    private let customSegmenStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    private let stackLeft:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    private let stackRight:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
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
    
    
    private func addSubviews(){
        stackLeft.addArrangedSubview(labelfirstSegment)
        stackLeft.addArrangedSubview(line1)
        stackRight.addArrangedSubview(labelsecondSegment)
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
        labelsecondSegment.addGestureRecognizer(secondSegmentTapGesture)
        labelsecondSegment.isUserInteractionEnabled = true
        labelfirstSegment.addGestureRecognizer(firstSegmentTapGesture)
        labelfirstSegment.isUserInteractionEnabled = true
    }
    
    @objc private func firstSegmentTapped(){
        selectedSegment.send(0)
    }
    
    @objc private func secondSegmentTapped(){
        selectedSegment.send(1)
    }
    
    fileprivate func firstSegmentSelected() {
        
        labelfirstSegment.textColor = .none
        line1.layer.borderColor = labelfirstSegment.textColor?.cgColor
        labelsecondSegment.textColor = .gray
        line2.layer.borderColor = labelsecondSegment.textColor?.cgColor
        firstSegmentTapGesture.isEnabled = false
        secondSegmentTapGesture.isEnabled = true
        delegate?.firsSegmentSelected()
    }
    
    fileprivate func secondSegmentSelected() {
        
        labelfirstSegment.textColor = .gray
        line1.layer.borderColor = labelfirstSegment.textColor?.cgColor
        labelsecondSegment.textColor = .none
        line2.layer.borderColor = labelsecondSegment.textColor?.cgColor
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


