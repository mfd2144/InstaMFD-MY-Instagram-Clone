//
//  ContactsViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 20.07.2021.
//

import Foundation


final class ContactsViewModel:ContactsViewModelProtocol{
    weak var delegate: ContactsViewModelDelegate?
    var router:ContactsRouterProtocol!
    var contact = Contacts()
    var service:FirebaseUserServices!
  
    
    func fetchContactsPermission() {
        var i = 0
        var contacedtUserArray = Array<ContactedUserPresentation>()
        delegate?.handleOutput(.isLoading(true))
        contact.getContact() {[unowned self] results in
            switch results{
            case .success(let contacts):
                guard let contacts = contacts else { delegate?.handleOutput(.isLoading(false));return}
                service.searchUserContacts(contacts: contacts) { result in
                    switch result{
                    case.failure(let error):
                        delegate?.handleOutput(.isLoading(false))
                        guard let err = error as? GeneralErrors else {return}
                        delegate?.handleOutput(.anyErrorOccured(err.description))
                    case.success(let contactedUser):
                        guard let contactedUser = contactedUser as? [ContactedUserPresentation] else {return}
                        
                        
                        contacedtUserArray.append(contentsOf: contactedUser)
                        
                        i += 1
                        if i == 2{
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                delegate?.handleOutput(.isLoading(false))
                                let user = Set(contacedtUserArray)
                                let array = Array(user).sorted(by: {$0.userName < $1.userName})
                                router.routeToPage(.toAddContactsPage(array, self))
                            }
                          
                        }
                    }
                   
                }
                
            case .failure(let error):
                delegate?.handleOutput(.isLoading(false))
                let errorDescription = (error as! GeneralErrors).description
                delegate?.handleOutput(.anyErrorOccured(errorDescription))
            }
        }
        
    }
    
    func skip() {
        router.routeToPage(.nextPage)    }
    
}

extension ContactsViewModel:ContactedUserParentProtocol{
    func goOnToNextPage() {
        router.routeToPage(.nextPage)
    }
}

