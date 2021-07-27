//
//  UserPageViewModel.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 22.07.2021.
//

import Foundation

final class UserPageViewModel:UserPageViewModelProtocol{
    weak var delegate: UserPageViewModelDelegate?
    var userService :FirebaseUserServices!
    
    func fetchUserInfo(){
        userService.getUserBasicInfo {[unowned self] result in
            switch result{
            case.success(let basicUser):
                guard let user = basicUser as? BasicUserInfo else {return}
                delegate?.handleOutputs(.fetchUser(user))
            case .failure(let error):
                guard let error = error as? GeneralErrors else {return}
                delegate?.handleOutputs(.showAnyAlert(error.description))
            }
        }
    }
    
    func menuButton() {
        
    }
    
    func editMenu() {
        
    }
    
    func myPhotos() {
        
    }
    
    func taggedPhotos() {
        
    }
    
    func logOut() {
        do{
            try appContainer.authService.signOut()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func selectCell(_ type: SelectedCellType) {
        switch  type {
        case .addPhotoFromAlbum:
            break
        case .changeUserPhoto:
            break
        case .showAlbumPhoto:
            break
        case .showCompletePhoto:
            break
        }
    }
    
    
}
