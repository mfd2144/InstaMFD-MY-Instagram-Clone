//
//  SignUpMethodPage.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation

enum SignUpMethodModelOutput{
    case resultOfCodes(Results<Any>)
    case pushPhoneVerificationAlert(Results<Any>?)
    case signupMethodResult(Results<Any>)
    
}

protocol SignUpMethodModelProtocol:AnyObject{
    var delegate: SignUpMethodModelDelegate? {get set}
    func fetchCodes()
    func validateEntryType(_ type: Entrytype)
    func checkPhoneVerificationCode(verificationCode:String)
}


protocol SignUpMethodModelDelegate:AnyObject{
    func handleOutput(_ output: SignUpMethodModelOutput)
}



enum Entrytype:Equatable{
    case phoneNumber(PhoneNumber)
    case email(String)
}

protocol SignUpMethodViewModelProtocol:AnyObject{
    var delegate:SignUpMethodViewModelDelegate? {get set}
    func checkEntry(_ entry:Entrytype)
    func routeToCodesPage()
    func countryCodeChecker()->String
    func checkVerificationCode(code: String)
}

enum SignUpMethodViewModelOutputs:Equatable{
    case showAnyAlert(String)
    case getVerificationCode
    case isLoading(Bool)
}

protocol SignUpMethodViewModelDelegate:AnyObject{
   func handleOutput(_ output:SignUpMethodViewModelOutputs)
}

enum SingUpMethodRoutes{
    case alredyHaveAccount(String)
    case userNamePage(BasicUserInfo)
    case countryCodesPage([CountryCode])
}

protocol SignUpMethodRouterProtocol:AnyObject{
    func routeToPage(_ route:SingUpMethodRoutes)
}

enum SignUpMethodErrors:Error{
   case phoneVerificationError(String)
}

