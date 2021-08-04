//
//  SelectAlbumBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import UIKit

final class SelectAlbumBuilder{
    static func make(_ albums:[AlbumPresentation],delegate:NewPostParentProtocol)->UIViewController{
        let view = SelectAlbumView()
        let viewModel = SelectAlbumViewModel()
        view.viewModel = viewModel
        viewModel.parentDelegate = delegate
        viewModel.delegate = view
        viewModel.albums = albums
        return view
        
    }
    
    
}
