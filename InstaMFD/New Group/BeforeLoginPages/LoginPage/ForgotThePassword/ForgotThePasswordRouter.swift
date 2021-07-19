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
        case.empty:
            break
        case.toCodePage(let countryCodes):
            let codeView = CountryBuilder.make(countryCodes)
            view.navigationController?.pushViewController(codeView, animated: true)
        case.toUserBirthday(let userInfo):
            break
        case .toUserPage:
            break
        }
    }
    
  
    

    
    
}
