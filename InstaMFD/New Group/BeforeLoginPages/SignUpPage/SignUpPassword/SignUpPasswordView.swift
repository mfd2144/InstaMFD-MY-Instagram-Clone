//
//  File.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//


import UIKit
import Combine


final class SignUpPasswordView:UIViewController{
    var viewModel:SignUpPasswordViewModel!

    
    let mainstack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()
    let topStack :UIStackView = {
        let label1 = UILabel()
        label1.text = "Set Your Password"
        label1.textAlignment = .center
        label1.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label1.textColor = .none
        let label2 = UILabel()
        label2.text = "Your password must have minimum six character with uppercase character and number"
        label2.numberOfLines = 0
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label2.textColor = .lightGray
        let stack = UIStackView(arrangedSubviews: [label1,label2])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        stack.alignment = .fill
        
        return stack
    }()
    
    let textField: PasswordFieldWithEye = {
        let textField = PasswordFieldWithEye()
        textField.borderStyle = .roundedRect
        textField.setRightPaddingPoints(10)
        return textField
    }()
    
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemTeal
        return button
    }()
    
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSubviews()
        textField.delegate = self
        navigationItem.hidesBackButton = true
        addButtonTarget()
    }
    
    //MARK: - Set subviews
    private func setSubviews(){
        let views = [topStack,textField,nextButton]
        for _view in views{
            mainstack.addArrangedSubview(_view)
        }
        view.addSubview(mainstack)
        mainstack.putSubviewAt(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 100, bottomDis: 0, leadingDis: 30, trailingDis: -30, heightFloat: 230, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    //MARK: - Add button target
    
    private func addButtonTarget(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed(){
        textField.endEditing(true)
        viewModel.nextButtonPressed(textField.text!)
    }
}

//MARK: - ViewModelOutputs
extension SignUpPasswordView:SignUpPasswordViewModelDelegate{
    func handleOutput(_ output: SignUpPasswordViewModelOutput) {
        switch output {
        case .nextButtonResult(let result):
            switch result {
            case .failure(let error):
                guard let err = error as? GeneralErrors else {return}
                addCaution(title: "Caution", message: err.description)
            case .success:
                viewModel.saveUserInformation()
            }
        case .isLoading(let setLoading):
            setLoading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case .savingProcess( let error):
            switch error {
            case .failure(let err):
                guard let err = err as? GeneralErrors else {return}
                addCaution(title: "Caution", message: "\(err.description) \n Description: \(err.localizedDescription)")
            default:
                break
            }
        }
    }
}

extension SignUpPasswordView:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed()
        return true
    }
}

