//
//  AddProfilePhotoViewContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import Foundation


protocol AddProfilePhotoViewModelProtocol:AnyObject {
    var delegate:AddProfilePhotoViewModelDelegate? {get set}
    func skip()
    func openPicker()
    func saveImageToStorage(_ imgData:Data?)
    
}

enum AddProfilePhotoViewModelOutputs{
    case isLoading(Bool)
    case showAnyAlert(String)
    
    
}
protocol AddProfilePhotoViewModelDelegate :AnyObject{
    func handleOutput(_ output:AddProfilePhotoViewModelOutputs)
}


enum AddProfilePhotoRoutes{
    case nextPage
    case toPickerView
}
protocol AddProfilePhotoRouterProtocol:AnyObject {
    func routeToPage(_ route: AddProfilePhotoRoutes)
}
