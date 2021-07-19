//
//  LoginContracts.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit



protocol LoginViewModelProtocol:AnyObject{
    var delegate :LoginViewModelDelegate? {get set}
    func logIn(_ userName:String,_ password:String)
    func forgetPassword(_ userName: String?)
    func fbButtonPressed()
    func singUp()

}

enum LoginModelOutputs{
    case loggedIn(Results<Any>)
    case setLoading(Bool)
    
}

protocol LoginViewModelDelegate:AnyObject{
    func handleModelOutputs(_ output:LoginModelOutputs)
}

enum LoginRoutes{
    case signUpPage
    case fogotPassword(String?)
    case toUserPage
    case toUserBirthday(UserInfo)
}

protocol LoginRouterProtocol:AnyObject{
    func routeToPage(_ page: LoginRoutes)
    
}


