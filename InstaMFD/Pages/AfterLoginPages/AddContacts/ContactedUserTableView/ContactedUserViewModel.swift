//
//  ContactedUserViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 3.08.2021.
//

import Foundation


final class ContactedUserViewModel :ContactedUserViewModelProtocol {
    weak var delegate: ContactedUserViewModelDelegate?
    var contacs :[ContactedUserPresentation]!
    var service: FirebaseUserServices!
    var parentDelegate:ContactedUserParentProtocol!
    
    func showContactedUsers() {
        delegate?.handleOutput(.sendContects(contacs))
    }
    

    func saveUserToDatabase(_ usersWillAdded: Array<ContactedUserPresentation>){
        delegate?.handleOutput(.isLoading(true))
        service.saveOtherUsersAsFriends(usersWillAdded) { [unowned self]result in
            delegate?.handleOutput(.isLoading(false))
            switch result{
            case.failure(let error):
                guard let err = error as? GeneralErrors else { return }
                delegate?.handleOutput(.anyErrorOccured(err.description))
            case .success:
                delegate?.handleOutput(.addProccessFinished)
                parentDelegate.goOnToNextPage()
            }
        }
    }
}

