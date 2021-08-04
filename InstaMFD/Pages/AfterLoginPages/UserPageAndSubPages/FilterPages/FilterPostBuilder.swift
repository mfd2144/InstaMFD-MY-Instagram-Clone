//
//  FilterPostBuilder.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import UIKit

final class FilterPostBuilder{
    static func make(_ imageContainer:ImageContainer)->UIViewController{
        let view = FilterPostView(collectionViewLayout: UICollectionViewLayout())
        let viewModel = FilterPostViewModel(container: imageContainer)
        viewModel.delegate = view
        view.viewModel = viewModel
        
        return view
    }
}
