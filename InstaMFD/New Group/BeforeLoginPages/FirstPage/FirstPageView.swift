//
//  FirstPageView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit


final class FirstPageView:UIViewController,FirstPageViewModelDelegate{
    var model :FirstPageViewModelProtocol!
    
    private let instaLabel :UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Cookie-Regular", size: 50)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Instagram"
        label.textAlignment = .center
        return label
    }()
    
    private let emptyLabel :UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let newAccountButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("Create New Account", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemTeal
        return button
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let stack:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) 
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    
        
    }
    
    
//MARK: - Set StackView
    private func setStack(){
        let views = [instaLabel, emptyLabel, newAccountButton, loginButton ]
        for _view in views{
            stack.addArrangedSubview(_view)
        }
        view.addSubview(stack)
        
        stack.putSubviewAt(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 40, trailingDis: -40, heightFloat: UIScreen.main.bounds.height/3, widthFloat: nil, heightDimension: nil, widthDimension: nil)
        NSLayoutConstraint.activate([
                                        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    //MARK: - Add  buttons' target and function
    private func addButtonTarget(){
        newAccountButton.addTarget(self, action: #selector(newAccountPushed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(logInPushed), for: .touchUpInside)
    }
    
    @objc private func newAccountPushed(){
        model.goToPage(.createNewUserPage)
    }
    

    @objc private func  logInPushed(){
        model.goToPage(.logIn)
    }
    
}

