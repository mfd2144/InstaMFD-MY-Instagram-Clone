//
//  ContactedUserBuilder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 3.08.2021.
//

import UIKit

final class ContactedUserBuilder{
    static func make(parentDelegate:ContactedUserParentProtocol ,_ contactedUserPresentations: [ContactedUserPresentation])->UIViewController{
        let view = ContactedUserView()
        let viewModel = ContactedUserViewModel()
        
        view.viewModel = viewModel
        viewModel.delegate = view
        viewModel.contacs = contactedUserPresentations
        viewModel.service = appContainer.userService
        viewModel.parentDelegate = parentDelegate
        
        return view
    }
}
