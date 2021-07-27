//
//  UserPageBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import UIKit


final class UserPageBuilder{
    static func make()->UIViewController{
        let view = UserPageView(collectionViewLayout: UICollectionViewLayout())
        let viewModel = UserPageViewModel()
        view.viewModel = viewModel
        viewModel.delegate = view
        viewModel.userService = appContainer.userService
        return view
        
    }
}
