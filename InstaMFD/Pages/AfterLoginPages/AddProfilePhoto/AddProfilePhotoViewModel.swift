//
//  AddProfilePhotoViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 26.07.2021.
//

import Foundation


final class AddProfilePhotosViewModel:AddProfilePhotoViewModelProtocol{
    weak var delegate: AddProfilePhotoViewModelDelegate?
    var router:AddProfilePhotoRouterProtocol!
    var userService:FirebaseUserServices!
    
    func saveImageToStorage(_ imgData:Data?){
        guard let data = imgData else {delegate?.handleOutput(.showAnyAlert("Empty image Data")); return }
        delegate?.handleOutput(.isLoading(true))
        userService.addPhotoToDB(data) {[weak self] result in
            guard let self = self else {return}
            self.delegate?.handleOutput(.isLoading(false))
            switch result{
            case.failure(let error):
                print((error as? GeneralErrors)?.description)
            case.success:
                print("success")
            }
        }
    }
    
    func openPicker(){
        router.routeToPage(.toPickerView)
    }
    
    func skip() {
        router.routeToPage(.nextPage)
    }
    
}
