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
    var authService :FirebaseAuthenticationService!
    
    
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
            authService.sendVerificationNumberToPhone(number.copleteNumber){ [unowned self ]result in
                switch result{
                case.failure(let error):
                    delegate?.handleOutput(.pushPhoneVerificationAlert(.failure(GeneralErrors.unspesificError(error.localizedDescription))))
                case .success:
                    delegate?.handleOutput(.pushPhoneVerificationAlert(.success(nil)))
                }
                
                
            }
        }
    }
    
    
    func checkPhoneVerificationCode(verificationCode:String){
        guard let phone = phoneNumber else {delegate?.handleOutput(.pushPhoneVerificationAlert(.failure(GeneralErrors.unspesificError("unkonwn phone number error"))));return }
        
        authService.checkPhoneVerificationCode(verificationCode: verificationCode, phone: phone) {[unowned self] result in
            switch result{
            case.success:
                delegate?.handleOutput(.signupMethodResult(.success(Entrytype.phoneNumber(phone))))
            case.failure(let error):
                delegate?.handleOutput(.signupMethodResult(.failure(error)))
            }
        }
    }
    
    
  
    
   
    
}


