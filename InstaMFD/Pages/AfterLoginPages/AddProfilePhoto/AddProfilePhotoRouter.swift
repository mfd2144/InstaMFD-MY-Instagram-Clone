//
//  AddProfilePhotoRouter.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import UIKit


final class AddProfilePhotoRouter:AddProfilePhotoRouterProtocol{
    unowned var view: AddProfilePhotoView!
    var photoPicker: PhotoPicker?
    
    func routeToPage(_ route: AddProfilePhotoRoutes) {
        switch route {
        case .nextPage:
            let newView = UserPageBuilder.make()
            let navController = UINavigationController(rootViewController: newView)
            navController.modalPresentationStyle = .fullScreen
            navController.modalTransitionStyle = .coverVertical
            view.present(navController, animated: true, completion: nil)
        case.toPickerView:
            photoPicker = PhotoPicker(view: view, delegate: view)
            photoPicker?.present()
        }
    }
    
    
}
