//
//  SignUpPasswordBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit

final class SignUpPasswordBuilder{
    static func make(_ usernIfo:UserInfo)->UIViewController{
        let view = SignUpPasswordView()
        let router = SignUpPasswordRouter()
        let viewModel = SignUpPasswordViewModel()
        view.viewModel = viewModel
        viewModel.router = router
        router.view = view
        viewModel.delegate = view
        viewModel.userInformation = usernIfo
        viewModel.authService = appContainer.authService
        return view
    }
}
