//
//  SignUpMethodPageVİew.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit
import Combine

final class SignUpMethodView:UIViewController{
    
    var signUpMethodViewModel:SignUpMethodViewModel!
    
    let textValeus = CurrentValueSubject<[String],Never>(["",""])
    var instantValue = PassthroughSubject<String,Never>()
    
    let selectedSegment = CurrentValueSubject<Int,Never>(0)
    var subscriptions = Set<AnyCancellable>()
    let service = CodesService()
    var emailTapGesture:UITapGestureRecognizer!
    var phoneTapGesture:UITapGestureRecognizer!
    var codeTapGesture:UITapGestureRecognizer!
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Phone or Email"
        label.textAlignment = .center
        label.textColor = .none
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        return label
    }()
    
    
    let customSegmenStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    let stackLeft:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    let stackRight:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    let labelPhone:UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.textAlignment = .center
        label.textColor = .none
        return label
    }()
    
    let labelEmail:UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textAlignment = .center
        label.textColor = .none
        return label
    }()
    let line1:UIImageView = {
        let imageV = UIImageView()
        imageV.layer.borderWidth = 2
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return imageV
    }()
    
    let line2:UIImageView = {
        let imageV = UIImageView()
        imageV.layer.borderWidth = 2
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return imageV
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.setRightPaddingPoints(10)
        return textField
    }()
    
    let seperator: UIImageView = {
        let imageV = UIImageView()
        imageV.layer.cornerRadius = 2
        imageV.contentMode = .scaleAspectFill
        imageV.backgroundColor = .lightGray
        return imageV
    }()
    
    let codeField:UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.setLeftPaddingPoints(10)
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .clear
        return textField
    }()
    
    let codeGestureLayer : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    
    //MARK: - App life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Singleton.shared.dialCode != ""{
            codeField.text = Singleton.shared.dialCode
        }
        listener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSubviews()
        setTarget()
        setGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscriptions.forEach { $0.cancel()}
        Singleton.shared.dialCode = ""
        codeField.gestureRecognizers?.removeAll()

    }
    
    
    //MARK: - Listener
    
    fileprivate func listener() {
        // listen to labels and textFields
        
        selectedSegment.sink {[unowned self] segmentIndex in
            if segmentIndex == 0{
                phoneSelected()
            }else{
                emailSelected()
            }
        }.store(in: &subscriptions)
        
        
        instantValue.sink {[unowned self] value in
            if value != ""{
                switch selectedSegment.value {
                case 0:
                    textValeus.send([textValeus.value[0],value])
                default:
                    textValeus.send([value,textValeus.value[1]])
                }
            }
        }.store(in: &subscriptions)
    }
    //MARK: - Custom segment controller methods
    
    fileprivate func phoneSelected() {
        
        labelPhone.textColor = .none
        line1.layer.borderColor = labelPhone.textColor?.cgColor
        labelEmail.textColor = .gray
        line2.layer.borderColor = labelEmail.textColor?.cgColor
        codeField.isHidden = false
        seperator.isHidden = false
        textField.insetsLayoutMarginsFromSafeArea = false
        textField.setLeftPaddingPoints(55)
        textField.resignFirstResponder()
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        instantValue.send(textField.text!)
        textField.text = textValeus.value[0]
        phoneTapGesture.isEnabled = false
        emailTapGesture.isEnabled = true
        if codeField.text == ""{
            codeField.text = signUpMethodViewModel.countryCodeChecker()
        }
      
    }
    
    fileprivate func emailSelected() {
        
        labelPhone.textColor = .gray
        line1.layer.borderColor = labelPhone.textColor?.cgColor
        labelEmail.textColor = .none
        line2.layer.borderColor = labelEmail.textColor?.cgColor
        codeField.isHidden = true
        seperator.isHidden = true
        textField.setLeftPaddingPoints(10)
        instantValue.send(textField.text!)
        textField.resignFirstResponder()
        textField.keyboardType = .emailAddress
        textField.becomeFirstResponder()
        textField.text = textValeus.value[1]
        phoneTapGesture.isEnabled = true
        emailTapGesture.isEnabled = false
        
    }
    
    //MARK: - Add subviews
    
    private func setSubviews(){
        
        stackLeft.addArrangedSubview(labelPhone)
        stackLeft.addArrangedSubview(line1)
        stackRight.addArrangedSubview(labelEmail)
        stackRight.addArrangedSubview(line2)
        customSegmenStack.addArrangedSubview(stackLeft)
        customSegmenStack.addArrangedSubview(stackRight)
        let views = [titleLabel,customSegmenStack,textField,nextButton]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        
        view.addSubview(stack)
        stack.putSubviewAt(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 150, bottomDis: 0, leadingDis: 30, trailingDis: -30, heightFloat: UIScreen.main.bounds.height/3, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
        textField.addSubview(codeField)
        textField.addSubview(seperator)
        
        codeField.putSubviewAt(top: textField.topAnchor, bottom: textField.bottomAnchor, leading: textField.leadingAnchor, trailing: nil, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: 50, heightDimension: nil, widthDimension: nil)
        
        seperator.putSubviewAt(top: textField.topAnchor, bottom: textField.bottomAnchor, leading: codeField.trailingAnchor, trailing: nil, topDis: 5, bottomDis: -5, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: 3, heightDimension: nil, widthDimension: nil)
        
        view.addSubview(codeGestureLayer)
        codeGestureLayer.putSubviewAt(top: codeField.topAnchor, bottom: codeField.bottomAnchor, leading: codeField.leadingAnchor, trailing: codeField.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        
    }
    
    //MARK: - Add Gestures and methods
    private func setGestures(){
        emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        phoneTapGesture = UITapGestureRecognizer(target: self, action:#selector(phoneTapped))
        labelEmail.addGestureRecognizer(emailTapGesture)
        labelEmail.isUserInteractionEnabled = true
        labelPhone.addGestureRecognizer(phoneTapGesture)
        labelPhone.isUserInteractionEnabled = true
        codeTapGesture = UITapGestureRecognizer(target: self, action: #selector(codeFieldTapped))
        codeGestureLayer.addGestureRecognizer(codeTapGesture)
        codeGestureLayer.isUserInteractionEnabled = true
    }
    
    
    @objc private func codeFieldTapped(){
        signUpMethodViewModel.routeToCodesPage()
    }
    
    @objc private func phoneTapped(){
        selectedSegment.send(0)
    }
    
    @objc private func emailTapped(){
        selectedSegment.send(1)
    }
    
    //MARK: - Add target
    private func setTarget(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed(){
        
        if selectedSegment.value == 0{
            signUpMethodViewModel.checkEntry(.phoneNumber(PhoneNumber(code: codeField.text!, body: textField.text!)))
        }else{
            signUpMethodViewModel.checkEntry(.email(textField.text!))
        }
    }
    
}


extension SignUpMethodView:SignUpMethodViewModelDelegate{
    func handleOutput(_ output: SignUpMethodViewModelOutputs) {
        switch output {
        case .showAnyAlert(let caution):
            addCaution(title: "Caution", message: caution)
        case .getVerificationCode:
            verificationAlert()
        case .isLoading(let loading):
            if loading{
                Animator.sharedInstance.showAnimation()
            }else{
                Animator.sharedInstance.hideAnimation()
            }
          
        }
    }
    private func verificationAlert(){
        let alert = UIAlertController(title: "Verification Code", message: "Enter sending verification code", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionAccept = UIAlertAction(title: "Accept", style: .default){ [weak self]_ in
            guard let self = self,let code = alert.textFields?.first?.text else {return}
            self.signUpMethodViewModel.checkVerificationCode(code: code)
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionAccept)
        present(alert, animated: true, completion: nil)
     
    }
    
}




