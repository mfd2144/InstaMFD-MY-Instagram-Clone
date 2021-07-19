//
//  SignUpMethodPageViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation

final class SignUpMethodViewModel:SignUpMethodViewModelProtocol{

    weak var delegate: SignUpMethodViewModelDelegate?
    var model : SignUpMethodModelProtocol!{
        didSet{
            if countryCodes.count == 0{
                model.fetchCodes() }
        }
    }
    
    var router: SignUpMethodRouterProtocol!
    var countryCodes = [CountryCode]()
    
    
    
    func checkEntry(_ entry: Entrytype) {
        delegate?.handleOutput(.isLoading(true))
        switch entry {
        case .email(let email):
            // world shortest email adress has 7 character
            guard email.contains("@"),email.contains("."), email.count >= 7   else {
                delegate?.handleOutput(.showAnyAlert("Unvalid email type"))
                delegate?.handleOutput(.isLoading(false))
                return}
            model.validateEntryType(.email(email))
        case .phoneNumber(let number):
            guard number.body.count >= 8, number.body.contains(where: { $0.isWholeNumber}) else {
                delegate?.handleOutput(.showAnyAlert("Unvalid phone type"))
                delegate?.handleOutput(.isLoading(false))
                return}
            model.validateEntryType(.phoneNumber(number))
        }
    }
    
    func routeToCodesPage() {
        router.routeToPage(.countryCodesPage(countryCodes))
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
    
    func checkVerificationCode(code: String) {
        delegate?.handleOutput(.isLoading(true))
        model.checkPhoneVerificationCode(verificationCode: code)
    }
}

extension SignUpMethodViewModel:SignUpMethodModelDelegate{
    func handleOutput(_ output: SignUpMethodModelOutput) {
        switch output {
        case .resultOfCodes(let codeResult):
            switch codeResult {
            case .failure(let error):
                guard let error = error as? DecodeErrors else {return}
                delegate?.handleOutput(.showAnyAlert(error.description))
                break
            case .success(let results):
                guard let results = results as? [CountryCode] else {return}
                countryCodes = results
                
            }
            
        case .pushPhoneVerificationAlert(let result):
            switch result {
            case .failure(let err):
                delegate?.handleOutput(.showAnyAlert("Verification Error \(err.localizedDescription)"))
            default:
                delegate?.handleOutput(.getVerificationCode)
            break
            }
            
        case .signupMethodResult(let result):
            delegate?.handleOutput(.isLoading(false))
            switch result {
            case .failure(let error):
                delegate?.handleOutput(.showAnyAlert("Login Error \(error.localizedDescription)"))
            case .success(let mailOrPhone):
                guard let mailOrPhone = mailOrPhone as? Entrytype else{return}
                var userInfo:UserInfo?
                switch mailOrPhone {
                case .email(let mail):
                    userInfo = UserInfo(userName: nil, date: nil, password: nil, mail: mail)
                case .phoneNumber(let phone):
                    userInfo = UserInfo(userName: nil, date: nil, password: nil, phone: phone.body)
                }
                guard let userInfo = userInfo else {return}
                router.routeToPage(.userNamePage(userInfo))
            }
        case .isLoading(let setLoading):
            delegate?.handleOutput(.isLoading(setLoading))
        }
    }
    
    
}
