//
//  ContactedUserView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 3.08.2021.
//

import UIKit

final class ContactedUserView:UITableViewController{
    //MARK: - Properties
    var viewModel:ContactedUserViewModelProtocol!
    var contacts = Array<ContactedUserPresentation>()
    var selected = Array<ContactedUserPresentation>()
    //MARK: - View properties
    
    lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        return button
    }()
    
     //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ContactedUserCell.self, forCellReuseIdentifier: ContactedUserCell.identifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = 120
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = addBarButton
        viewModel.showContactedUsers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Tableview data source and delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactedUserCell.identifier, for: indexPath) as? ContactedUserCell
        cell?.setCell(user: contacts[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selected.append(contacts[indexPath.row])
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            let user = contacts[indexPath.row]
            guard let index = selected.firstIndex(of: user) else {return}
            selected.remove(at: index)
        }
        
 
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   //MARK: - Methods
    
    @objc private func addButtonPressed(){
        viewModel.saveUserToDatabase(selected)
    }
    
}

extension ContactedUserView:ContactedUserViewModelDelegate{
    func handleOutput(_ output: ContactedUserViewModelOutputs) {
        switch output {
        case .sendContects(let contactedUsers):
            contacts = contactedUsers
            tableView.reloadData()
        case .isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case.anyErrorOccured(let caution):
            addCaution(title: "Caution", message: caution)
        case.addProccessFinished:
            navigationController?.popViewController(animated: true)
   
           
        }
    }
    
    
}
