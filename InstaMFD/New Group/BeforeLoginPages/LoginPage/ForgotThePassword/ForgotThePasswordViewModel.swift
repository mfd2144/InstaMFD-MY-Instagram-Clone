//
//  ForgotThePasswordViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation

final class ForgotThePasswordViewModel:ForgotThePasswordViewModelProtocol{
   weak var delegate: ForgotThePasswordViewModelDelegate?
    var router : ForgotThePasswordRouterProtocol!
    var countryCodeService:CodesServiceProtocol!
    var authService: FirebaseAuthenticationService!
    var countryCodes = [CountryCode]()
    

    func fbButtonPressed() {
        
            delegate?.handleOutput(.isLoading(true))
            authService.loginWithFB {[unowned self] results in
                delegate?.handleOutput(.isLoading(false))
                switch results{
                case.success(let userInfo):
                    if let userInfo = userInfo as? BasicUserInfo {
                        //first time sign up with facebook so user have to enter his/her birtday to save user information to firebase
                        router.routeToPage(.toUserBirthday(userInfo))
                    }else{
                        //face book login success but user alredy account in our system
                        //direct to user page
                        router.routeToPage(.toUserPage)
                    }
                   
                case .failure(let error):
                    guard let error = error as? GeneralErrors else {return}
                    delegate?.handleOutput(.showAnyAlert(error.description))
                }
            }
    }
    
    func nextButtonPressed(_ entry: Entrytype) {
        delegate?.handleOutput(.isLoading(true))
        switch entry {
        case .email(let email):
            // world shortest email adress has 7 character
            guard email.contains("@"),email.contains("."), email.count >= 7   else {
                delegate?.handleOutput(.showAnyAlert("Unvalid email type"))
                delegate?.handleOutput(.isLoading(false))
                return}
            authService.sendEmailPasswordReset(email: email) {[unowned self] results in
                delegate?.handleOutput(.isLoading(false))
                switch results{
                case.failure(let error):
                    guard let error = error as? GeneralErrors else {return}
                    delegate?.handleOutput(.showAnyAlert(error.description))
                case .success:
                    delegate?.handleOutput(.verificationCodeSend)
                }
            }
            
        case .phoneNumber(let number):
            guard number.body.count >= 8, number.body.contains(where: { $0.isWholeNumber}) else {
                delegate?.handleOutput(.showAnyAlert("Unvalid phone type"))
                delegate?.handleOutput(.isLoading(false))
                return}
            //todo
        }
    }
    
    func countryCodeChecker() -> String {
        if let isoCode: String = NSLocale.current.regionCode{
            for country in countryCodes{
                if country.isoCode == isoCode{
                    return country.dialCode
                }
            }
        }
        return "+1"
    }
    
    
    func routeToCodePage() {
        router.routeToPage(.toCodePage(countryCodes))
    }
    func fetchCodes() {
        countryCodeService.fetchCodes {[unowned self] results in
            switch results{
            case .failure(let error):
                guard let error = error as? DecodeErrors else {return}
                delegate?.handleOutput(.showAnyAlert(error.description))
            case .success(let response):
                guard let fetchResult = response?.results else {
                    delegate?.handleOutput(.showAnyAlert(DecodeErrors.emptyData.description))
                    return}
                countryCodes = fetchResult
            }
        }
    }
    
}




