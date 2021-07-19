//
//  SignUpMethodModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 13.07.2021.
//

import Foundation
import FirebaseAuth

final class SignUpMethodModel:SignUpMethodModelProtocol{
    
    weak var delegate: SignUpMethodModelDelegate?
    unowned var service:CodesServiceProtocol!
    var phoneNumber:PhoneNumber?
    
    func fetchCodes() {
        service.fetchCodes {[unowned self] results in
            switch results{
            case .failure(let error):
                delegate?.handleOutput(.resultOfCodes(.failure(error)))
            case .success(let response):
                guard let fetchResult = response?.results else {
                    delegate?.handleOutput(.resultOfCodes(.failure(DecodeErrors.emptyData)))
                    return}
                delegate?.handleOutput(.resultOfCodes(.success(fetchResult)))
            }
        }
    }
    
    func validateEntryType(_ type: Entrytype) {
        switch type {
        case .email(let email):
            delegate?.handleOutput(.signupMethodResult(.success(Entrytype.email(email))))
           
        case .phoneNumber(let number):
            phoneNumber = number
            sendVerificationNumberToPhone(number.copleteNumber)
        }
    }
    
    
    func checkPhoneVerificationCode(verificationCode:String){
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {return}
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) {[unowned self] authResult, error in
            
            if let error = error {
                delegate?.handleOutput(.isLoading(false))
                delegate?.handleOutput(.signupMethodResult(.failure(error)))
            }else{
                guard let phone = phoneNumber else {return}
                let phoneMail = "\(phone.body)@phonenumber.com"
                authResult?.user.updateEmail(to:phoneMail , completion: { error in
                    delegate?.handleOutput(.isLoading(false))
                    if let error = error {
                        delegate?.handleOutput(.signupMethodResult(.failure(error)))
                    }
                    else{
                        delegate?.handleOutput(.signupMethodResult(.success(Entrytype.phoneNumber(phone))))
                    }
                })
            }
            
        }
    }
    
    
  
    
    fileprivate func sendVerificationNumberToPhone(_ number: (String)) {
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) {[unowned self] verificationID, error in
            delegate?.handleOutput(.isLoading(false))
            if let error = error {
                delegate?.handleOutput(.pushPhoneVerificationAlert(.failure(SignUpMethodErrors.phoneVerificationError(error.localizedDescription))))
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            delegate?.handleOutput(.pushPhoneVerificationAlert(nil))
        }
    }
    
}


