//
//  NewPostContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation


protocol NewPostViewModelProtocol:AnyObject{
    var delegate: NewPostViewModelDelegate? {get set}
//    private func getSmartPhotos(albumRawValue: Int?)
//    private func getAlbumPhotos(albumTitle: String)
    func getAlbumPhotos()
    func showPhoto(_ container:ImageContainer)
 
    func selectAlbum()
}

enum NewPostViewModelOutputs{
    case anyCaution(String)
    case isLoading(Bool)
    case photos([ImageContainer])
    case setAlbumNAme(String)
}

protocol NewPostViewModelDelegate:AnyObject{
    func handleOutput(_ output:NewPostViewModelOutputs)
}

enum NewPostRoutes{
    case albumSelectPage([AlbumPresentation],delegate:NewPostParentProtocol)
    case filterPage(ImageContainer)
}

protocol NewPostRouterProtocol{
    func routeToPage(_ page: NewPostRoutes)
    
}


//talk with previous view controller(userPage)
protocol NewPostParentProtocol:AnyObject{
    func getAlbumName(album:AlbumPresentation)
}
