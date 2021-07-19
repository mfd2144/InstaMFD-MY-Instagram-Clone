//
//  SignUpPasswordViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation


final class SignUpPasswordViewModel:SignUpPasswordViewModelProtocol{
    var delegate: SignUpPasswordViewModelDelegate?
    var router:SignUpPasswordRouterProtocol!
    var userInformation:UserInfo?
    var authService: FirebaseAuthenticationService?
    
    func nextButtonPressed(_ password: String) {
        delegate?.handleOutput(.isLoading(true))
        guard password.count > 5 else {
            delegate?.handleOutput(.isLoading(false))
            delegate?.handleOutput(.nextButtonResult(.failure(GeneralErrors.unsufficientText)))
            return}
        
        var logicUppercase = false
        var logicLowercase = false
        var logicNumber = false
        var logicSymbol = false
        
        password.forEach({ char in
            if char.isWholeNumber{
                logicNumber = true
            }else if char.isUppercase{
                logicUppercase = true
            }else if char.isLowercase{
                logicLowercase = true
            }else if char.isASCII{
                logicSymbol = true
            }
        })
        
        guard logicSymbol,logicLowercase,logicUppercase,logicNumber else {
            delegate?.handleOutput(.isLoading(false))
            delegate?.handleOutput(.nextButtonResult(.failure(GeneralErrors.unvalidText)))
            return
        }
        userInformation?.password = password
        delegate?.handleOutput(.nextButtonResult(.success(nil)))
    }
    
    func saveUserInformation() {
        guard let userInformation = userInformation else {
            delegate?.handleOutput(.isLoading(false))
            delegate?.handleOutput(.savingProcess(.failure(GeneralErrors.unspesificError(nil))))
            return
        }
        if userInformation.phone != nil{
            //user sign up with phone
            saveOtherPhoneInformations()
          
        }else if userInformation.mail != nil{
          // user sign up with email
            signUpWithEmail()
        }
        
    }
    
    private func saveOtherPhoneInformations(){
      
        authService?.saveUserOtherInformations(userInfos:userInformation!){ [unowned self] result in
            delegate?.handleOutput(.isLoading(false))
            switch result{
            case .failure(let error):
                delegate?.handleOutput(.savingProcess(.failure(error)))
            case .success:
                router.routeToPage(.toUserPage)
            }
            
        }
    }

    private func signUpWithEmail(){
       
        authService?.createNewUserWithEmail(userInfos: userInformation!){ [unowned self] result in
            delegate?.handleOutput(.isLoading(false))
            switch result{
            case .failure(let error):
                delegate?.handleOutput(.savingProcess(.failure(error)))
            case .success:
                router.routeToPage(.toUserPage)
            }
            
        }
    
    }
  
    
}
