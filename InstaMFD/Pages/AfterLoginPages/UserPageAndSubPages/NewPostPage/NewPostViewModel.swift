//
//  NewPostViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 27.07.2021.
//

import Foundation

final class NewPostViewModel:NewPostViewModelProtocol, AlbumProviderProtocol{
    func reloadData(_ list: [AlbumCollection]) {
        delegate?.handleOutput(.loadAlbum(list.first!))
    }
  
    
    
    weak  var delegate: NewPostViewModelDelegate?
    var router:NewPostRouterProtocol!
    var albumProvider = AlbumProvider()

    func getAlbumPhotos(){
        albumProvider.delegate = self
    }
    
    
    func nextPage(_ container: ImageContainer) {
        router.routeToPage(.next(container))
    }
    
    
    func selectAlbum() {
        router.routeToPage(.albumSelectPage(delegate: self))
        
    }
}

extension NewPostViewModel:NewPostParentProtocol{
    func getAlbumName(album: AlbumCollection) {
        delegate?.handleOutput(.loadAlbum(album))
    }
}

