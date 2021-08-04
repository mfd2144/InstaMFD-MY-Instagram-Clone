//
//  File.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import UIKit


final class ForgotThePasswordBuilder{
    static func make(_ userInfo:String?)->UIViewController{
        let view = ForgotThePasswordView()
        let viewModel = ForgotThePasswordViewModel()
        let router = ForgotThePasswordRouter()
        let codeService = CodesService()
        
        view.model = viewModel
        viewModel.delegate = view
        viewModel.authService = appContainer.authService
        viewModel.userService = appContainer.userService
        viewModel.countryCodeService = codeService
        viewModel.router = router
        router.view = view
        
        return view
    }
}
