//
//  LoginViewModel.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import Foundation
import FBSDKLoginKit
import Firebase



final class LoginViewModel:LoginViewModelProtocol{
    
    var service: FirebaseAuthenticationService!
    weak var delegate: LoginViewModelDelegate?
    var router :LoginRouterProtocol!
    
    func logIn(_ userName: String, _ password: String) {
        var numberLogic = true
        var email:String!
        
        
        delegate?.handleModelOutputs(.setLoading(true))
        //Check password and email is empty
        if userName.isEmpty || password.isEmpty{
        delegate?.handleModelOutputs(.setLoading(false))
            delegate?.handleModelOutputs(.loggedIn(.failure(GeneralErrors.emptyFieldError)))
            return
        }
        // Check it is a phone number or email
        for char in userName{
            numberLogic = numberLogic && char.isWholeNumber
        }
        
        //for log in with phone number
        if numberLogic{
           email = userName+"@phonenumber.com"
        }else{
            email = userName
        }
        
        //Sign in method
        service.signIn(emailOrPhoneNumber: email, Password: password) {[weak self] result in
            guard let self = self else {return}
            self.delegate?.handleModelOutputs(.setLoading(false))
            switch result{
            case.failure(let error):
                self.delegate?.handleModelOutputs(.loggedIn(.failure(error)))
            case.success:
                self.router.routeToPage(.toUserPage)
            }
        }
    }
    
    
    func forgetPassword(_ userName: String?) {
        router.routeToPage(.fogotPassword(userName))
    }
    
    func singUp() {
        router.routeToPage(.signUpPage)
    }
    
    func fbButtonPressed() {
        delegate?.handleModelOutputs(.setLoading(true))
        service.loginWithFB {[unowned self] results in
            delegate?.handleModelOutputs(.setLoading(false))
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
                delegate?.handleModelOutputs(.loggedIn(.failure(error)))
            }
        }
    }
    
}


