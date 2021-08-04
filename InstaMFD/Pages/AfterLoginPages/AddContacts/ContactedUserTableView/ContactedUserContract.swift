//
//  ContactedUserContract.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 3.08.2021.
//

import Foundation


protocol ContactedUserViewModelProtocol:AnyObject{
    var delegate : ContactedUserViewModelDelegate? {get set}
    func showContactedUsers()
    func saveUserToDatabase(_ usersWillAdded: Array<ContactedUserPresentation>)

}

enum ContactedUserViewModelOutputs{
    case sendContects([ContactedUserPresentation])
    case isLoading(Bool)
    case anyErrorOccured(String)
    case addProccessFinished
}

protocol ContactedUserViewModelDelegate:AnyObject{
    
    func handleOutput(_ output:ContactedUserViewModelOutputs)
    
}

protocol ContactedUserParentProtocol{
    func goOnToNextPage()
}
