//
//  LoginRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import Foundation


final class LoginRouter:LoginRouterProtocol{
    unowned var view:LoginView!
    
    
    func routeToPage(_ page: LoginRoutes) {
        switch page{
        case.fogotPassword(let username):
            let forgotView = ForgotThePasswordBuilder.make(username)
            view.navigationController?.pushViewController(forgotView, animated: true)
        case.signUpPage:
            let newView = SignUpMethodBuilder.make()
            view.navigationController?.pushViewController(newView, animated: true)
       
        case.toUserPage:
            let newView = UserPageBuilder.make()
            appContainer.router.startAnyNewView(newView, navControlller: true)
        
        case.toUserBirthday(let userInfo):
            let birtdayView = SignUpBirthdayPageBuilder.make(userInfo)
            birtdayView.modalPresentationStyle = .currentContext
            view.present(birtdayView, animated: true, completion: nil)
            }
        }
}
        
    
    
    
    

    
    

