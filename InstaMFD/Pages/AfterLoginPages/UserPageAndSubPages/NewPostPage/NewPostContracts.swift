//
//  NewPostContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation


protocol NewPostViewModelProtocol:AnyObject{
    var delegate: NewPostViewModelDelegate? {get set}
    func nextPage(_ container: ImageContainer)
    func getAlbumPhotos()
    func selectAlbum()
}

enum NewPostViewModelOutputs{
    case anyCaution(String)
    case isLoading(Bool)
    case setAlbumNAme(String)
    case loadAlbum(AlbumCollection)
}

protocol NewPostViewModelDelegate:AnyObject{
    func handleOutput(_ output:NewPostViewModelOutputs)
}

enum NewPostRoutes{
    case albumSelectPage(delegate:NewPostParentProtocol)
    case next(ImageContainer)
}

protocol NewPostRouterProtocol{
    func routeToPage(_ page: NewPostRoutes)
}

protocol NewPostParentProtocol:AnyObject{
    func getAlbumName(album:AlbumCollection)
}
