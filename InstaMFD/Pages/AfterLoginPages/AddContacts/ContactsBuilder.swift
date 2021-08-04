//
//  ContactsBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 21.07.2021.
//

import UIKit

final class ContactsBuilder{
    static func make()->UIViewController{
        let view = ContactsView()
        let viewModel = ContactsViewModel()
        let router = ContactsRouter()
        view.model = viewModel
        viewModel.delegate = view
        viewModel.router = router
        viewModel.service = appContainer.userService
        router.view = view
        return view
    }
}
