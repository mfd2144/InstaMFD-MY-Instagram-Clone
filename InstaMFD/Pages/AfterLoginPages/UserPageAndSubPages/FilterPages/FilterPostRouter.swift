//
//  FilterPostRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation
final class FilterPostRouter:FilterPostRouterProtocol{
    unowned var view: FilterPostView!
    
    func toNextPage(_ container: ImageContainer) {
        let nextPage = AddImageDBBuilder.make(container)
        view.navigationController?.pushViewController(nextPage, animated: true)
    }
}
