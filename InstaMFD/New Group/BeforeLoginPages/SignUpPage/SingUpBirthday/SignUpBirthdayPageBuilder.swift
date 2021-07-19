//
//  SignUpBirthdayPageBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit


final class SignUpBirthdayPageBuilder{
    static func make(_ userInfo: UserInfo)->UIViewController{
        let view = SignUpBirthdayPageView()
        let router = SignUpBirthdayPageRouter()
        let viewModel = SignUpBirthdayPageViewModel()
        view.viewModel = viewModel
        viewModel.router = router
        viewModel.userInfo = userInfo
        router.view = view
        viewModel.authService = appContainer.authService
        
        return view
    }
}
