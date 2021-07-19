//
//  SignUpPasswordContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation


protocol SignUpPasswordViewModelProtocol:AnyObject{
    var delegate:SignUpPasswordViewModelDelegate? {get set}
    func nextButtonPressed(_ password:String)
    func saveUserInformation()
}

enum SignUpPasswordViewModelOutput{
        case nextButtonResult(Results<Any>)
        case isLoading(Bool)
        case savingProcess(Results<Any>)
}
protocol SignUpPasswordViewModelDelegate:AnyObject{
    func handleOutput(_ output:SignUpPasswordViewModelOutput)
}

enum SignUpPasswordRoutes{
    case toUserPage
}

protocol SignUpPasswordRouterProtocol:AnyObject {
    func routeToPage(_ route:SignUpPasswordRoutes)
}
