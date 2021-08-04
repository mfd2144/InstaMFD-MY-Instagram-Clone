//
//  ContactsContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 20.07.2021.
//

import Foundation


protocol ContactsViewModelProtocol:AnyObject {
    var delegate:ContactsViewModelDelegate? {get set}
    func fetchContactsPermission()
    func skip()
    
}

enum ContactsViewModelOutputs{
    
    case isLoading(Bool)
    case anyErrorOccured(String)
    
    
}
protocol ContactsViewModelDelegate :AnyObject{
    func handleOutput(_ output:ContactsViewModelOutputs)
}


enum ContactsRoutes{
    case nextPage
    case toAddContactsPage([ContactedUserPresentation],ContactedUserParentProtocol)
}
protocol ContactsRouterProtocol:AnyObject {
    func routeToPage(_ route: ContactsRoutes)
}
