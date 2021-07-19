//
//  SignUpBirthdayPageViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit




final class SignUpBirthdayPageViewModel:SignUpBirthdayPageViewModelProtocol{
   weak var delegate: SignUpBirthdayPageViewModelDelegate?
    var userInfo:UserInfo?
    var router:SignUpBirthdayPageRouterProtocol!
    var authService: FirebaseAuthenticationService?
    
    func nextButtonPressed(_ date:Date) {
        delegate?.handleOutputs(.isLoading(true))
        guard var userInfo = userInfo else {return}
        if userInfo.isFBAccount == true {
            //this is for facebook user first itme sign up to system
            userInfo.date = date
            authService?.addFBUserInfo(userInfo: userInfo, completion: {[unowned self] result in
                delegate?.handleOutputs(.isLoading(false))
                switch result{
                case.failure(let error):
                    delegate?.handleOutputs(.anyKindError(error))
                    FBLogOut.sharedInstance.logOut()
                break
                case.success:
                    router.routeToPage(.toUserPage)
                }
            })
        }else{
            delegate?.handleOutputs(.isLoading(true))
            userInfo.date = date
            router.routeToPage(.passwordPage(userInfo))
        }
       
    }
    
    
}
