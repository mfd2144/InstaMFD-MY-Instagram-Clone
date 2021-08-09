//
//  AddImageDBViewBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import Foundation

import UIKit

final class AddImageDBBuilder{
    static func make(_ container: ImageContainer)->UIViewController{
        let view = AddImageDBView()
        let viewModel = AddImageDBViewModel()
        let router = AddImageDBRouter()
        view.imageContainer = container
        view.viewModel = viewModel
        viewModel.delegate = view
        viewModel.router = router
        router.view = view
        return view
    }
}

