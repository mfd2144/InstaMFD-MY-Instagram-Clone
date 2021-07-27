//
//  AddPhotoBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import Foundation


import UIKit

final class AddProfilePhotoBuilder{
    static func make()->UIViewController{
        let view = AddProfilePhotoView()
        let viewModel = AddProfilePhotosViewModel()
        let router = AddProfilePhotoRouter()
        view.viewModel = viewModel
        viewModel.delegate = view
        viewModel.router = router
        viewModel.userService = appContainer.userService
        router.view = view
        
        return view
    }
}
