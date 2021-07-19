//
//  SignupUserNameViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation
final class SignupUserNameViewModel:SignupUserNameProtocol{
    weak var delegate: SignupUserNameDelegate?
    var userInfo:UserInfo?
    
    var router:SignupUserNameRouterProtocol!
    
    func nextButtonPressed(_ userName:String) {
        if userName == ""{
            delegate?.handleOutputs(.resultAfterNextPressed(.failure(GeneralErrors.emptyFieldError)))
        }else if userName.count < 5{
            delegate?.handleOutputs(.resultAfterNextPressed(.failure(GeneralErrors.unsufficientText)))
           
        }else{
            guard var userInfo = userInfo else{return}
            userInfo.userName = userName
            router.routeToPage(.birtdayPage(userInfo))
        }
      
    }
    
    
}
