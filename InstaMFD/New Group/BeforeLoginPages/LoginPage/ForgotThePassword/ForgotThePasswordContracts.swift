//
//  ForgotThePasswordContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation


protocol ForgotThePasswordViewModelProtocol:AnyObject{
    var delegate: ForgotThePasswordViewModelDelegate? {get set}
    func fbButtonPressed()
    func countryCodeChecker()->String
    func routeToCodePage()
    func fetchCodes()
    func checkVerificationCode(code: String)
    func nextButtonPressed(_ entry: Entrytype)
   
}
enum ForgotThePasswordViewModelOutputs{
    case isLoading(Bool)
    case showAnyAlert(String)
    case verificationCodeSend
    case getVerificationCode
}

protocol ForgotThePasswordViewModelDelegate:AnyObject{
    func handleOutput(_ output:ForgotThePasswordViewModelOutputs)
}

enum ForgotThePasswordViewModelRoutes{
    case toPasswordPage(BasicUserInfo)
    case toUserBirthday(BasicUserInfo)
    case toCodePage([CountryCode])
    case toUserPage
    
}

protocol ForgotThePasswordRouterProtocol:AnyObject{
    func routeToPage(_ route: ForgotThePasswordViewModelRoutes)
}
