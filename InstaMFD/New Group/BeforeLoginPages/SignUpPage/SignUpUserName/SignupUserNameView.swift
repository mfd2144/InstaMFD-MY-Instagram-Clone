//
//  SignupUserNameView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit


final class SignupUserNameView:UIViewController{
    var viewModel:SignupUserNameViewModel!
    
    
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
        label1.text = "Add Your Name"
        label1.textAlignment = .center
        label1.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label1.textColor = .none
        let label2 = UILabel()
        label2.text = "Add your name so friends can find you"
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
    
    let textField: UITextField = {
        let textField = UITextField()
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
        addButtonTarget()
    }
    
    //MARK: - Set subviews
    private func setSubviews(){
        let views = [topStack,textField,nextButton]
        for _view in views{
            mainstack.addArrangedSubview(_view)
        }
        view.addSubview(mainstack)
        mainstack.putSubviewAt(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 100, bottomDis: 0, leadingDis: 30, trailingDis: -30, heightFloat: 200, widthFloat: nil, heightDimension: nil, widthDimension: nil)
    }
    //MARK: - Add button target
    
    private func addButtonTarget(){
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc private func nextButtonPressed(){
        viewModel.nextButtonPressed(textField.text!)
        
    }
    
}

extension SignupUserNameView:SignupUserNameDelegate{
    func handleOutputs(_ output: SignupUserNamOutput) {
        switch  output {
        case .resultAfterNextPressed(let result):
            switch result {
            case .failure(let error):
                guard let err = error as? GeneralErrors else {return}
                addCaution(title: "Caution", message:err.description)
            default:
                break
            }
        }
    }
    
    
}



