//
//  FilterPostContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation



protocol FilterPostViewModelProtocol:AnyObject{
    var delegate:FilterPostViewModelDelegate? {get set}
    func executeFilter()
    func saveImageToFirebase(_ imageContainer:ImageContainer)
    
}


enum FilterPostViewModeloutputs{
    case anyErrorOccured(String)
    case isloading(Bool)
    case afterFilterExecuted([FilteredImageContainer])
    case originalPhoto
}

protocol FilterPostViewModelDelegate:AnyObject{
    func handleOutputs(_ output:FilterPostViewModeloutputs)
}
