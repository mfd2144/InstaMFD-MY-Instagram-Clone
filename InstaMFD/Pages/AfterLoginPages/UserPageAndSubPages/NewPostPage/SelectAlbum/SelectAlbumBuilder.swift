//
//  SelectAlbumBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import UIKit

final class SelectAlbumBuilder{
    static func make(delegate:NewPostParentProtocol?)->UIViewController{
        let view = SelectAlbumView()
        let viewModel = SelectAlbumViewModel()
        view.viewModel = viewModel
        viewModel.parentDelegate = delegate
        viewModel.delegate = view
        viewModel.albumProvider = AlbumProvider()
        return view
    }
}
