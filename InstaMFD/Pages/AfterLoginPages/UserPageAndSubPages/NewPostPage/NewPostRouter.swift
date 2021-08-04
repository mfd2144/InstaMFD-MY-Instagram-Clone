//
//  NewPostRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation

final class NewPostRouter:NewPostRouterProtocol{
    unowned var view:NewPostView!
    
    func routeToPage(_ page: NewPostRoutes) {
        switch page {
        case .albumSelectPage(let albums,let delegate):
            let newView = SelectAlbumBuilder.make(albums,delegate:delegate)
            view.navigationController?.pushViewController(newView, animated: true)
        case.filterPage(let container):
            let newView = FilterPostBuilder.make(container)
            view.navigationController?.pushViewController(newView, animated: true)
        }
    }
    
    
}
