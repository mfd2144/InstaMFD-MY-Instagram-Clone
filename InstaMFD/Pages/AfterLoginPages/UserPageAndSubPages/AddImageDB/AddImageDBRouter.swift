//
//  AddImageDBViewRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import Foundation

final class AddImageDBRouter:AddImageDBRouterProtocol{
    unowned var view:AddImageDBView!
    
    func routeToPage(_ route: AddImageDBRoutes) {
        switch route {
        case .toAddLocation:
            break
        case .toAddUsers:
            break
        case .toUserPage:
            break
            
        }
    }
    
    
}
