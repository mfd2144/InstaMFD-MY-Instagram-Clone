//
//  SelectAlbumContracts.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import Foundation



protocol SelectAlbumViewModelProtocol:AnyObject{
    var delegate:SelectAlbumViewModelDelegate? {get set}
    func selectAnAlbum(_ collection: AlbumCollection)
    func loadAlbums()
}

enum SelectAlbumOutputs{
    case albumData([AlbumCollection])
}

protocol  SelectAlbumViewModelDelegate:AnyObject {
    func handleOutputs(_ outputs: SelectAlbumOutputs)
}
