//
//  LoginView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 17.07.2021.
//

import UIKit

class FirstPageAfterLogin:UIViewController{
    private let logoutButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("logout", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemTeal
        return button
    }()
   
    let stack:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill

        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setStack()
        addButtonTarget()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    
//MARK: - Set StackView
    private func setStack(){
        stack.addArrangedSubview(logoutButton)
        view.addSubview(stack)
        
        stack.putSubviewAt(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 40, trailingDis: -40, heightFloat: UIScreen.main.bounds.height/3, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        NSLayoutConstraint.activate([
                                        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    //MARK: - Add  buttons' target and function
    private func addButtonTarget(){
        logoutButton.addTarget(self, action: #selector(logoutPushed), for: .touchUpInside)
    }
    
 
    
    @objc private func logoutPushed(){
        let service = FirebaseAuthenticationService()
        do{
        try service.signOut()
        }catch{
            print(error)
        }
    }
  
}
