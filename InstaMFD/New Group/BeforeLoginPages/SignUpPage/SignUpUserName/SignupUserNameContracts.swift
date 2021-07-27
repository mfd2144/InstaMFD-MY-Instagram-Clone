//
//  SingupUserNameContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

enum SignupUserNamOutput{
    case resultAfterNextPressed(Results<Any>)
}

protocol SignupUserNameProtocol:AnyObject{
    var delegate: SignupUserNameDelegate? {get set}
    func nextButtonPressed(_ userName:String)
}

protocol SignupUserNameDelegate:AnyObject{
    func handleOutputs(_ output: SignupUserNamOutput)
}

enum SignupUserNameRoutes{
    case birtdayPage(BasicUserInfo)
}

protocol SignupUserNameRouterProtocol:AnyObject {
    func routeToPage(_ route:SignupUserNameRoutes)
}
