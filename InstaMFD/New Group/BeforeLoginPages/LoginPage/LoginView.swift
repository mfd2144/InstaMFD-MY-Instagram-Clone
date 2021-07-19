//
//  LoginView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit
import Combine
import FBSDKLoginKit


final class LoginView:UIViewController{
    var model:LoginViewModelProtocol!
    
   
    
    let stackView:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let nameField:UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.setRightPaddingPoints(10)
        field.placeholder = "Email or phone number"
        return field
        
    }()
    
    let passwordField:PasswordFieldWithEye = {
        let field = PasswordFieldWithEye()
        field.borderStyle = .roundedRect
        field.setRightPaddingPoints(10)
        field.placeholder = "Password"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
        
    }()
    
    let forgotThePassword:UILabel = {
        let label = UILabel()
        label.text = "Forgot password?"
        label.textAlignment = .right
        label.textColor = .systemTeal
        
        return label
    }()
    
    
    let loginButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemTeal
        button.setTitle("Log In", for: .normal)
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
  
    let cautionLabel:UILabel = {
        let label = UILabel()
        label.text = "Don't have a account?"
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fBButton.delegate = self
        setSubviews()
        setTargets()
        
    }
    
    
    //MARK: - Set subviews
    private func setSubviews(){
        
        
        let stackViews = [nameField,passwordField,forgotThePassword,loginButton,lineStack,fBButton]
        for view in stackViews{
            stackView.addArrangedSubview(view)
        }
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: 200)
            
        ])
        
        bottomInnerStack.addArrangedSubview(cautionLabel)
        bottomInnerStack.addArrangedSubview(signUpButton)
        bottomStack.addArrangedSubview(bottomInnerStack)
        view.addSubview(bottomStack)
        
        
        NSLayoutConstraint.activate([
            bottomStack.heightAnchor.constraint(equalToConstant: 75),
            bottomStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        
    }
    
    
    //MARK: - Add button target
    private func setTargets(){
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action:#selector(signUpButtonPressed), for: .touchUpInside)
    }
    
    @objc private func loginButtonPressed(_ sender: UIButton){
        model.logIn(nameField.text!, passwordField.text!)
    }
    
    @objc private func signUpButtonPressed(_ sender: UIButton){
        model.singUp()
    }
    
}

//MARK: - Outputs of model
extension LoginView:LoginViewModelDelegate{
    func handleModelOutputs(_ output: LoginModelOutputs) {
        switch output {
        case .loggedIn(let response):
            switch response {
            case .failure(let error):
                guard let error = error as? GeneralErrors else {return}
                
                switch error {
                case .unspesificError(let caution):
                    addCaution(title: "Fail", message: caution!)
                default:
                    addCaution(title: "Fail", message: error.description)
                }
            default:
               break
            }
            
        case .setLoading(let isLoading):
            if isLoading{
                Animator.sharedInstance.showAnimation()
            }else{
                Animator.sharedInstance.hideAnimation()
            }
        }
    }
}

extension LoginView:LoginButtonDelegate{
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
        addCaution(title: "Success", message: "logged out")

    }
}



