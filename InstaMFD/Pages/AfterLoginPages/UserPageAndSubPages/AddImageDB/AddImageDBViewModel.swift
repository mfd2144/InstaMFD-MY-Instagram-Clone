//
//  AddImageDBViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import Foundation

final class AddImageDBViewModel:AddImageDBViewModelProtocol{
    
    
    weak var delegate: AddImageDBViewModelDelegate?
    var router:AddImageDBRouter!
  
    
    func saveToDB(image: ImageContainer) {
        //service
    }
    
  
    
    func handleinputs(_ input: AddImageDBViewModelInputs) {
        switch input {
        case .toAddLocation:
            router.routeToPage(.toAddLocation)
        case .toAddUser:
            router.routeToPage(.toUserPage)
        }
    }
    
    
    
}
