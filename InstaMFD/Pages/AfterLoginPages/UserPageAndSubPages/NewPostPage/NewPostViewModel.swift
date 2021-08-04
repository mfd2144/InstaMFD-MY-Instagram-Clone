//
//  NewPostViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 27.07.2021.
//

import Foundation

final class NewPostViewModel:NewPostViewModelProtocol{
  
    
    weak  var delegate: NewPostViewModelDelegate?
    var router:NewPostRouterProtocol!
    let smartAlbumChoicer = SmartAlbumChoicer()
    var actualAlbum: AlbumPresentation?

    
    init() {
        smartAlbumChoicer.delegate = self
        
    }
    
    
    func getAlbumPhotos() {
        delegate?.handleOutput(.isLoading(true))
        if let album = actualAlbum{
            //User select any album
            if album.smartAlbum == 1,let rawValue = album.albumType{
                //smart album
                getSmartPhotos(albumRawValue: rawValue)
            }else {
                //custom user album
                getAlbumPhotos(albumTitle: album.albumName)
            }
        }else{
            
            getSmartPhotos(albumRawValue: nil)
        }
        
    }
    
    private func getSmartPhotos(albumRawValue: Int?) {
        smartAlbumChoicer.selectSmartAlbumImages(albumTypeRawValue: albumRawValue)
    }
    
   private func getAlbumPhotos(albumTitle: String){
        smartAlbumChoicer.selectAlbumImages(title: albumTitle)
    }
    
    func showPhoto(_ container:ImageContainer) {
        router.routeToPage(.filterPage(container))
    }
    
 
    
    func selectAlbum() {
        guard  smartAlbumChoicer.albums.count > 0 else {return}
        router.routeToPage(.albumSelectPage(smartAlbumChoicer.albums, delegate: self))
    }
}


extension NewPostViewModel:SmartAlbumChoicerProtocol{
    func endOfAlbum() {
        delegate?.handleOutput(.isLoading(false))
    }
    
    func anyError(_ errorDescription: String) {
        delegate?.handleOutput(.isLoading(false))
        delegate?.handleOutput(.anyCaution(errorDescription))
    }
    
    func sendImages(images: [ImageContainer]) {
        delegate?.handleOutput(.isLoading(false))
        delegate?.handleOutput(.photos(images))
    }
}




extension NewPostViewModel:NewPostParentProtocol{
    func getAlbumName(album: AlbumPresentation) {
        delegate?.handleOutput(.setAlbumNAme(album.albumName))
        actualAlbum = album
        if album.smartAlbum == 1{
            guard let type = album.albumType else {return}
            getSmartPhotos(albumRawValue:type )
        }
        else{
            getAlbumPhotos(albumTitle: album.albumName)
        }
    }
    
    
}



