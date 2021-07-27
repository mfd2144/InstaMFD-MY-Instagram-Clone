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
    
    func fetchContactsPermission() {
        delegate?.handleOutput(.isLoading(true))
        contact.getContact() {[unowned self] results in
            delegate?.handleOutput(.isLoading(false))
            switch results{
            case .success(let contacts):
                break
            case .failure(let error):
                delegate?.handleOutput(.isLoading(false))
                delegate?.handleOutput(.anyErrorOccured(error as! GeneralErrors))
            }
        }
        
    }
    
    
    
    
    func skip() {
        router.routeToPage(.nextPage)
    }
    
    
    
}

