//
//  SignupUserNameRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

final class SignupUserNameRouter:SignupUserNameRouterProtocol{
    unowned var view :SignupUserNameView!
    
    func routeToPage(_ route: SignupUserNameRoutes) {
        switch route {
        case .birtdayPage(let userInfo):
            let birtdayView = SignUpBirthdayPageBuilder.make(userInfo)
            view.navigationController?.pushViewController(birtdayView, animated: true)
        }
        
    }
    
    
}
