//
//  AddImageDBContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import Foundation

enum AddImageDBViewModelInputs{
    case toAddUser
    case toAddLocation
}

protocol AddImageDBViewModelProtocol:AnyObject{
    var delegate:AddImageDBViewModelDelegate? {get set}
    func saveToDB(image:ImageContainer)

    func handleinputs(_ input:AddImageDBViewModelInputs)
   
}

enum AddImageDBViewModelOutputs{
    case isLoading(Bool)
    case anyErrorOccured(String)
    case loadImage(ImageContainer)
}

protocol AddImageDBViewModelDelegate:AnyObject{
    func handleOutputs(_ output: AddImageDBViewModelOutputs)
}

enum  AddImageDBRoutes {
    case toAddLocation
    case toAddUsers
    case toUserPage
}

protocol AddImageDBRouterProtocol:AnyObject{
    func routeToPage(_ route: AddImageDBRoutes)
}
