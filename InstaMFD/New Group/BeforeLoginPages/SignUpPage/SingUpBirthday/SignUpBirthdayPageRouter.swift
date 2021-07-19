//
//  SignUpBirthdayPageRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

final class SignUpBirthdayPageRouter:SignUpBirthdayPageRouterProtocol{
    weak var view :SignUpBirthdayPageView!
    
    func routeToPage(_ route: SignUpBirthdayPageRoutes) {
        switch  route {
        case .passwordPage(let userInfo):
            let newView = SignUpPasswordBuilder.make(userInfo)
            view.navigationController?.pushViewController(newView, animated:true)
        case.toUserPage:
            let userPage = FirstPageAfterLogin()
            appContainer.router.startAnyNewView(userPage, navControlller: true)
        }
    }
    
}
