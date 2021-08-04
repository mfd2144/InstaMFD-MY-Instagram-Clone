//
//  ForgotThePasswordView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import UIKit
import Combine
import FBSDKLoginKit

final class ForgotThePasswordView:UIViewController{
    var model:ForgotThePasswordViewModelProtocol!
    let textValeus = CurrentValueSubject<[String],Never>(["",""])
    var instantValue = PassthroughSubject<String,Never>()
    var subscriptions = Set<AnyCancellable>()
    let service = CodesService()
    var codeTapGesture:UITapGestureRecognizer!
    
    
    let lockImage:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "lock.circle")?.withRenderingMode(.alwaysOriginal).applyingSymbolConfiguration(.init(weight: .thin))
        imageView.image = image
        image?.withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trouble logging in?"
        label.textAlignment = .center
        label.textColor = .none
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your username or email and we'll send you a link to get back into your account?"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .none
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let customSegment:CustomSegmentController = {
        let segment = CustomSegmentController(firstSegment: "Phone", SecondSegment: "Email")
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.setRightPaddingPoints(10)
        textField.setLeftPaddingPoints(55)
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
    
    
    let stackView:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let nextButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemTeal
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    let lineStack:UIStackView = {
        let image = UIImageView(image: UIImage(systemName: "line.horizontal.3"))
        let image2 = UIImageView(image: UIImage(systemName: "line.horizontal.3"))
        let label = UILabel()
        label.text = "OR"
        label.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [image,label,image2])
        stack.axis = .horizontal
        stack.alignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        label.widthAnchor.constraint(equalTo:stack.widthAnchor, multiplier: 0.1),
                                        label.heightAnchor.constraint(equalToConstant: 20),
                                        image.widthAnchor.constraint(equalTo:stack.widthAnchor, multiplier: 0.45),
                                        image2.widthAnchor.constraint(equalTo:stack.widthAnchor, multiplier: 0.45),
                                        image.heightAnchor.constraint(equalToConstant: 10),
                                        image2.heightAnchor.constraint(equalToConstant: 10)])
        
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    let fBButton :FBLoginButton = {
        let button = FBLoginButton()
        let layoutConstraintsArr = button.constraints
        // Iterate over array and test constraints until we find the correct one:
        for lc in layoutConstraintsArr { // or attribute is NSLayoutAttributeHeight etc.
            if ( lc.constant == 28 ){
                // Then disable it...
                lc.isActive = false
                break
            }
        }
        return button
    }()
  
  
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back To Log In", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layer.addBorder(edge: .top, color: .lightGray, thickness: 2)
        return stack
    }()
    
    let bottomInnerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        return stack
    }()
    
    //MARK: - Life cycle
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Singleton.shared.dialCode != ""{
            codeField.text = Singleton.shared.dialCode
        }else{
            codeField.text = model.countryCodeChecker()
        }
        listener()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        customSegment.delegate = self
        fBButton.delegate = self
        textField.delegate = self
        setSubviews()
        setTargets()
        setGestures()
        model.fetchCodes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscriptions.forEach { $0.cancel()}
        codeField.gestureRecognizers?.removeAll()
        Singleton.shared.dialCode = ""
        navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Set subviews
    private func setSubviews(){
        let stackViews = [lockImage,titleLabel,descriptionLabel,customSegment,textField,nextButton,lineStack,fBButton]
        for view in stackViews{
            stackView.addArrangedSubview(view)
        }
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant:view.frame.height/8),
            lockImage.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.25),
            titleLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.15),
            descriptionLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            customSegment.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            nextButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            textField.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            fBButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            lineStack.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1)
        ])
        

        bottomInnerStack.addArrangedSubview(backButton)
        bottomStack.addArrangedSubview(bottomInnerStack)
        view.addSubview(bottomStack)
        
        NSLayoutConstraint.activate([
            bottomStack.heightAnchor.constraint(equalToConstant: 75),
            bottomStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        textField.addSubview(codeField)
        textField.addSubview(seperator)
        
        codeField.putSubviewAt(top: textField.topAnchor, bottom: textField.bottomAnchor, leading: textField.leadingAnchor, trailing: nil, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: 50, heightDimension: nil, widthDimension: nil)
        
        seperator.putSubviewAt(top: textField.topAnchor, bottom: textField.bottomAnchor, leading: codeField.trailingAnchor, trailing: nil, topDis: 5, bottomDis: -5, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: 3, heightDimension: nil, widthDimension: nil)
        
        view.addSubview(codeGestureLayer)
        codeGestureLayer.putSubviewAt(top: codeField.topAnchor, bottom: codeField.bottomAnchor, leading: codeField.leadingAnchor, trailing: codeField.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: nil, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    
    
    //MARK: - Add button target
    private func setTargets(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        backButton.addTarget(self, action:#selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed(){
        textField.endEditing(true)
        if customSegment.selectedIndex == 0{
            model.nextButtonPressed(.phoneNumber(PhoneNumber(code: codeField.text!, body: textField.text!)))
        }else{
            model.nextButtonPressed(.email(textField.text!))
        }
    }
    
    @objc private func backButtonPressed(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Listener
    
    fileprivate func listener() {
        // listen to labels and textFields
        instantValue.sink {[unowned self] value in
            if value != ""{
                switch customSegment.selectedIndex {
                case 0:
                    textValeus.send([textValeus.value[0],value])
                default:
                    textValeus.send([value,textValeus.value[1]])
                }
            }
        }.store(in: &subscriptions)
    }

    
    //MARK: - Add Gestures and methods
    private func setGestures(){
        codeTapGesture = UITapGestureRecognizer(target: self, action: #selector(codeFieldTapped))
        codeGestureLayer.addGestureRecognizer(codeTapGesture)
        codeGestureLayer.isUserInteractionEnabled = true
    }
    
    
    @objc private func codeFieldTapped(){
        model.routeToCodePage()
    }
    
    //MARK: - Other Methods
    
    private func verificationAlert(){
        let alert = UIAlertController(title: "Verification Code", message: "Enter sending verification code", preferredStyle: .alert)
        alert.addTextField {textField in
            textField.keyboardType = .numberPad
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionAccept = UIAlertAction(title: "Accept", style: .default){[unowned self] _ in
            guard let code = alert.textFields?.first?.text else {return}
            model.checkVerificationCode(code: code)
        }

        alert.addAction(actionCancel)
        alert.addAction(actionAccept)
        present(alert, animated: true, completion: nil)
    }



}

//MARK: - Outputs of model
extension ForgotThePasswordView:ForgotThePasswordViewModelDelegate{
    func handleOutput(_ output: ForgotThePasswordViewModelOutputs) {
        switch output {
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case.showAnyAlert(let caution):
            addCaution(title: "Caution", message: caution)
        case .verificationCodeSend:

                let alertController = UIAlertController(title: "Caution", message: "Reset mail sent your email", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel){ [unowned self] _ in
                    navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action)
                present(alertController, animated: true)
                
                
        case.getVerificationCode:
            verificationAlert()
            
        }
    }
}


//MARK: - Segment Functions
extension ForgotThePasswordView:CustomSegmentControllerDelegate{
    func firsSegmentSelected() {
        codeField.isHidden = false
        seperator.isHidden = false
        textField.insetsLayoutMarginsFromSafeArea = false
        textField.setLeftPaddingPoints(55)
        textField.resignFirstResponder()
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        instantValue.send(textField.text!)
        textField.text = textValeus.value[0]
    }
    
    func secondSegmentSelected() {
        codeField.isHidden = true
        seperator.isHidden = true
        textField.setLeftPaddingPoints(10)
        instantValue.send(textField.text!)
        textField.resignFirstResponder()
        textField.keyboardType = .emailAddress
        textField.becomeFirstResponder()
        textField.text = textValeus.value[1]
    }
}

extension ForgotThePasswordView:LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let err = error {
            addCaution(title: "Fail", message: err.localizedDescription)
        }else if result?.isCancelled == true{
            addCaution(title: "Fail", message: "Facebook login cancelled")
        }else{
            model.fbButtonPressed()
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        addCaution(title: "Caution", message: "logged out")

    }
}

extension ForgotThePasswordView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed()
        return true
    }
}

