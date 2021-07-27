//
//  SignUpBirthdayPageView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit
import Combine

final class SignUpBirthdayPageView:UIViewController{
    var viewModel:SignUpBirthdayPageViewModel!
    let actualDate = CurrentValueSubject<String?,Never>(nil)
    var subscription = Set<AnyCancellable>()
    
    let mainstack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()
    
    
    let topStack :UIStackView = {
        let imageV = UIImageView()
        let image = UIImage(named: "cake")
        imageV.image = image
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        let label1 = UILabel()
        label1.text = "Add Your Birthday"
        label1.textAlignment = .center
        label1.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label1.textColor = .none
        let label2 = UILabel()
        label2.text = "This won't be part of your public profile."
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label2.textColor = .lightGray
        let stack = UIStackView(arrangedSubviews: [imageV,label1,label2])
        NSLayoutConstraint.activate([
                                        imageV.topAnchor.constraint(equalTo:stack.topAnchor ),
                                        imageV.heightAnchor.constraint(equalTo: stack.heightAnchor,multiplier: 0.6),
                                        imageV.widthAnchor.constraint(equalTo: stack.widthAnchor)])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setRightPaddingPoints(10)
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemTeal
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let datePicker:UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        return picker
    }()
     
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        textField.placeholder = Date.dateString()
        setSubviews()
        addButtonTarget()
        
        actualDate.sink {[unowned self] stringDate in
            if stringDate != nil{
                textField.text = stringDate
            }
        }.store(in: &subscription)
        
    }
    
    //MARK: - Set subviews
    private func setSubviews(){
        let views = [topStack,textField,nextButton]
        for _view in views{
            mainstack.addArrangedSubview(_view)
        }
        view.addSubview(mainstack)
        
        NSLayoutConstraint.activate([
                                        nextButton.heightAnchor.constraint(equalToConstant: 50),
                                        textField.heightAnchor.constraint(equalToConstant: 50)])
        mainstack.putSubviewAt(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 100, bottomDis: 0, leadingDis: 30, trailingDis: -30, heightFloat: 400, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
        view.addSubview(datePicker)
        datePicker.putSubviewAt(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: UIScreen.main.bounds.height/4, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
    }
    //MARK: - Add button target
    
    private func addButtonTarget(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        
    }
    
    
    @objc private func pickerChanged(_ picker:UIDatePicker){
        let date = picker.date
        actualDate.send(Date.dateString(date: date))
    }
    @objc private func nextButtonPressed(){
        if textField.text == ""{
            addCaution(title: "Caution", message: "You must enter your birthday")
        }else if datePicker.date.compare(Date()).rawValue != -1 {
            addCaution(title: "Caution", message: "You must enter valid date")
        }
        else{
            viewModel.nextButtonPressed(datePicker.date)
        }
    }
}


extension SignUpBirthdayPageView:SignUpBirthdayPageViewModelDelegate{
    func handleOutputs(_ outputs: SignUpBirthdayPageViewModelOutputs) {
        switch outputs {
        case .anyKindError(let error):
         guard let error = error as? GeneralErrors else {return}
            switch  error {
            case .unspesificError(let message):
                guard let message = message else {return}
                addCaution(title: "Caution", message: error.description+" "+message)
            default:
                addCaution(title: "Caution", message: error.description)
            }
            
        case .isLoading(let loading):
            if loading{
                Animator.sharedInstance.showAnimation()
            }else{
                Animator.sharedInstance.hideAnimation()
            }
        }
    }
    
    
}
