//
//  Router.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import Foundation

final class ForgotThePasswordRouter:ForgotThePasswordRouterProtocol{
    unowned var view:ForgotThePasswordView!
    
    func routeToPage(_ route: ForgotThePasswordViewModelRoutes) {
        switch route{
        case.toPasswordPage(let user):
            let passwordPage = SignUpPasswordBuilder.make(user)
            view.navigationController?.pushViewController(passwordPage, animated: true)
        case.toCodePage(let countryCodes):
            let codeView = CountryBuilder.make(countryCodes)
            view.navigationController?.pushViewController(codeView, animated: true)
        case.toUserBirthday(let userInfo):
            let birtdayView = SignUpBirthdayPageBuilder.make(userInfo)
            birtdayView.modalPresentationStyle = .currentContext
            view.present(birtdayView, animated: true, completion: nil)
        case .toUserPage:
            let userPage = ContactsBuilder.make()
            appContainer.router.startAnyNewView(userPage, navControlller: true)
        }
    }
    
  
    

    
    
}
