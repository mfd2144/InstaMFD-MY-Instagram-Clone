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
    var albums:[AlbumPresentation]!{
        didSet{
          albums = albums.sorted(by: {$0.smartAlbum > $1.smartAlbum})
        }
    }
    
    
    func selectAnAlbum(_ index:Int) {
        parentDelegate.getAlbumName(album:albums[index])
    }
    
    func loadAlbums() {
        delegate?.handleOutputs(.albumData(albums))
    }
    
    
}
