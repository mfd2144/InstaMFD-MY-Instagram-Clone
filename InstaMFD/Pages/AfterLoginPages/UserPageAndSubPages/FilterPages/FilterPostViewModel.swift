//
//  FilterPostViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation


final class FilterPostViewModel:FilterPostViewModelProtocol{
   weak var delegate: FilterPostViewModelDelegate?
    var filterModel:PhotoFilters
    var results = [FilteredImageContainer]()
    var router:FilterPostRouter!
    
    init(container:ImageContainer) {
        filterModel = PhotoFilters(container: container)
        filterModel.delegate = self
    }
    
    func executeFilter() {
        delegate?.handleOutputs(.afterFilterExecuted(results))
    }
    
    func saveImageToFirebase(_ imageContainer: ImageContainer) {
        router.toNextPage(imageContainer)
    }
    
}

extension FilterPostViewModel:PhotoFilterProtocol{
    func carryToContainer(_ container: [FilteredImageContainer]) {
        results = container
    }
}
