//
//  ContactsRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 20.07.2021.
//

import Foundation

final class ContactsRouter:ContactsRouterProtocol{
    unowned var view: ContactsView!
    func routeToPage(_ route: ContactsRoutes) {
        switch  route {
        case .nextPage:
            let newView = AddProfilePhotoBuilder.make()
            view.navigationController?.pushViewController(newView, animated: true)
        case.toAddContactsPage(let contacetedList,let parentDelegate):
            let newView = ContactedUserBuilder.make(parentDelegate:parentDelegate , contacetedList)
            
            view.navigationController?.pushViewController(newView, animated: true)
        }
    }
    
    
}
