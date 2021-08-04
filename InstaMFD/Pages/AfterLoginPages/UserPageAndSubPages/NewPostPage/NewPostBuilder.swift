//
//  NewPostBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 27.07.2021.
//

import UIKit

final class NewPostBuilder{
    static func make()->UIViewController{
        let view = NewPostView()
        let router = NewPostRouter()
        let viewModel = NewPostViewModel()
        view.viewModel = viewModel
        viewModel.delegate = view
        viewModel.router = router
        router.view = view
        return view
    }
}
