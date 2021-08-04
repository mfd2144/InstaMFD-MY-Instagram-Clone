//
//  SignUpMethodPageBuilder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 12.07.2021.
//

import UIKit

final class SignUpMethodBuilder{
    static func make()->UIViewController{
        let view = SignUpMethodView()
        let viewModel = SignUpMethodViewModel()
        let router = SignUpMethodRouter()
        let model = SignUpMethodModel()
        let service = CodesService()
       
        viewModel.router = router
        viewModel.delegate = view
        view.signUpMethodViewModel = viewModel
        model.service = service
        model.authService = appContainer.authService
        model.delegate = viewModel
        viewModel.model = model
        router.view = view
        
        return view
    }
}
