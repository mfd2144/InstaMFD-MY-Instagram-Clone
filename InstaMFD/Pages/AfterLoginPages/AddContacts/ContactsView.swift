//
//  ContactsView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 20.07.2021.
//

import UIKit

final class ContactsView:UIViewController{

    var model:ContactsViewModelProtocol!

    let topStack:UIStackView = {
        let label1 = UILabel()
        label1.text = "Find Contacts"
        label1.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        label1.textColor = .none
        label1.textAlignment = .center
        let label2 = UILabel()
        label2.text = "See which of your firends are already on instagram and choose who to follow"
        label2.textColor = .none
        label2.numberOfLines = 0
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 15, weight: .light)
        let stack = UIStackView(arrangedSubviews: [label1,label2])
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 10 , bottom: 0, right: 10)
        return stack
    }()


    let imageView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "search"))
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()

    let bottomStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 10 , bottom: 0, right: 10)
        return stack
    }()
    let buttonSkip: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemTeal, for: .normal)
        return button
    }()


    let buttonSearch: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("Search Your Contacts", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.none, for: .normal)
        return button
    }()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSubviews()
        addTargets()
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Set subviews
    private func setSubviews(){
        bottomStack.addArrangedSubview(buttonSearch)
        bottomStack.addArrangedSubview(buttonSkip)
        view.addSubview(bottomStack)
        view.addSubview(imageView)
        view.addSubview(topStack)
        bottomStack.putSubviewAt(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 0, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: 120, widthFloat: nil, heightDimension: nil, widthDimension: nil)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalTo:view.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        topStack.putSubviewAt(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, topDis: 50, bottomDis: 0, leadingDis: 0, trailingDis: 0, heightFloat: 150, widthFloat: nil, heightDimension: nil, widthDimension: nil)

    }
    //MARK: - add target
    private func addTargets(){
        buttonSkip.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
        buttonSearch.addTarget(self, action: #selector(searchContactPressed), for: .touchUpInside)
    }

    @objc private func skipPressed(){
        model.skip()
    }
    @objc private func searchContactPressed(){
        model.fetchContactsPermission()
    }
}

extension ContactsView:ContactsViewModelDelegate{
    func handleOutput(_ output: ContactsViewModelOutputs) {
        switch output {
        case .anyErrorOccured(let caution):
            addCaution(title: "Caution", message: caution)
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        }
    }


}
