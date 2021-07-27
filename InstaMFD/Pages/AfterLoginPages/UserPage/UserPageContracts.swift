//
//  UserPageContacts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 22.07.2021.
//

import Foundation


enum SelectedCellType{
    case showCompletePhoto
    case addPhotoFromAlbum
    case changeUserPhoto
    case showAlbumPhoto
}

protocol UserPageViewModelProtocol:AnyObject{
    var delegate: UserPageViewModelDelegate? {get set}
    func fetchUserInfo()
    func menuButton()
    func editMenu()
    func myPhotos()
    func taggedPhotos()
    func logOut()
    func selectCell(_ type:SelectedCellType)
}

enum UserPageViewModelOutputs{
    case isLoading(Bool)
    case showAnyAlert(String)
    case userName(String)
    case fetchUser(BasicUserInfo)
}

protocol UserPageViewModelDelegate:AnyObject {
    func handleOutputs(_ output: UserPageViewModelOutputs)
}


enum UserPageRoutes{
    
}

protocol UserPageRouter:AnyObject{
    func routeToPage(_ route: UserPageRoutes)
}
