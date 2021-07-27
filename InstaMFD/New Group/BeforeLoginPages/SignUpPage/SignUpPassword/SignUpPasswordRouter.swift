//
//  SignUpPasswordRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

final class SignUpPasswordRouter:SignUpPasswordRouterProtocol{

    unowned var view :SignUpPasswordView!
    
    func routeToPage(_ route: SignUpPasswordRoutes) {
        switch route {
        case .toUserPage:
            let  newView = ContactsBuilder.make()
            appContainer.router.startAnyNewView(newView, navControlller: true)
            
        }
    }
    
    
}
