//
//  SelectAlbumViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation

final class SelectAlbumViewModel:SelectAlbumViewModelProtocol{
    
    weak var parentDelegate:NewPostParentProtocol!
    weak var delegate: SelectAlbumViewModelDelegate?
    var albumProvider: AlbumProvider!

    
    func selectAnAlbum(_ collection: AlbumCollection) {
        parentDelegate.getAlbumName(album: collection)
    }


    func loadAlbums() {
        albumProvider.delegate = self
    }
}


extension SelectAlbumViewModel:AlbumProviderProtocol{
    func reloadData(_ list: [AlbumCollection]) {
        delegate?.handleOutputs(.albumData(list))
    }
}
