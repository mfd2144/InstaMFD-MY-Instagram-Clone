//
//  UserPageRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation


final class UserPageRouter:UserPageRouterProtocol{
    var view:UserPageView!
    
    func routeToPage(_ route: UserPageRoutes) {
        switch route {
        case .toNewPost:
            let post = NewPostBuilder.make()
            view.navigationController?.pushViewController(post, animated: true)
       
        }
    }
}
