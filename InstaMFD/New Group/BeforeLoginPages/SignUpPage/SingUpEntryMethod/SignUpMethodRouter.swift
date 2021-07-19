//
//  SignUpMethodPageRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import Foundation

final class SignUpMethodRouter:SignUpMethodRouterProtocol{
    
        unowned var view:SignUpMethodView!
    
    
    func routeToPage(_ route: SingUpMethodRoutes) {
        switch route {
        case .countryCodesPage(let countryCodes):
            let codeView = CountryBuilder.make(countryCodes)
            view.navigationController?.pushViewController(codeView, animated: true)
        case .userNamePage(let userInfo):
            let userName = SignupUserNameBuilder.make(userInfo)
            view.navigationController?.pushViewController(userName, animated: true)
        default:
            break
            //TODO
        }
    }
    

}
