//
//  SignUpBirthdayPage.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

enum SignUpBirthdayPageViewModelOutputs{
    case isLoading(Bool)
    case anyKindError(Error)
}

protocol SignUpBirthdayPageViewModelProtocol:AnyObject{
    var delegate:SignUpBirthdayPageViewModelDelegate? {get set}
    func nextButtonPressed(_ date:Date)
}

protocol SignUpBirthdayPageViewModelDelegate:AnyObject{
 
    func handleOutputs(_ outputs:SignUpBirthdayPageViewModelOutputs)
}

enum SignUpBirthdayPageRoutes{
    case passwordPage(UserInfo)
    case toUserPage
}

protocol SignUpBirthdayPageRouterProtocol:AnyObject {
    func routeToPage(_ route:SignUpBirthdayPageRoutes)
}
