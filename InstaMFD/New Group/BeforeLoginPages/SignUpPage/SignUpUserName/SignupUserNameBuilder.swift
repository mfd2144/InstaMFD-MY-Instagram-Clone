//
//  SignupUserNameBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit

final class SignupUserNameBuilder{
    static func make(_ userInfo:BasicUserInfo)->UIViewController{
        let view = SignupUserNameView()
        let router = SignupUserNameRouter()
        let viewModel = SignupUserNameViewModel()
        view.viewModel = viewModel
        viewModel.router = router
        viewModel.delegate = view
        router.view = view
        viewModel.userInfo = userInfo
        return view
    }
}
