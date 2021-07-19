//
//  ForgotThePasswordContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation


protocol ForgotThePasswordViewModelProtocol:AnyObject{
    var delegate: ForgotThePasswordViewModelDelegate? {get set}
    func nextButtonPressed()
    func fbButtonPressed()
    func countryCodeChecker()->String
    func routeToCodePage()
    func fetchCodes()
    func checkEntry(_ entry: Entrytype)
}
enum ForgotThePasswordViewModelOutputs{
    case isLoading(Bool)
    case showAnyAlert(String)
}

protocol ForgotThePasswordViewModelDelegate:AnyObject{
    func handleOutput(_ output:ForgotThePasswordViewModelOutputs)
}

enum ForgotThePasswordViewModelRoutes{
    case empty
    case toUserBirthday(UserInfo)
    case toCodePage([CountryCode])
    case toUserPage
    
}

protocol ForgotThePasswordRouterProtocol:AnyObject{
    func routeToPage(_ route: ForgotThePasswordViewModelRoutes)
}
