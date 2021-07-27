//
//  FirebaseUserServices.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 21.07.2021.
//

import Foundation
import Firebase



final class FirebaseUserServices{
    typealias result = (Results<Any>)->Void
    
    public func addPhotoToDB(_ data:Data,completion:@escaping result){
        let photoName = UUID().uuidString
        guard let userId = Auth.auth().currentUser?.uid else {return completion(.failure(GeneralErrors.unspesificError("User sign in error")))}
        let ref = Storage.storage().reference(withPath: "UserPhotos/\(userId)/ProfilePhotos/\(photoName)")
        ref.putData(data, metadata: nil) { [unowned self] _, error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            ref.downloadURL { url, error in
                if let error = error{
                    completion(.failure(GeneralErrors.unspesificError("Download Url Error \(error.localizedDescription)")))
                }
                guard let url = url else {return completion(.failure(GeneralErrors.unspesificError("Empty url")))}
                updateUserPhotoUrl(userID:userId,url, completion: completion)
            }
        }
        
    }
    
    private func updateUserPhotoUrl(userID:String,_ url:URL,completion:@escaping result){
        let ref = Firestore.firestore().collection(Cons.user).document(userID)
        
        ref.updateData([Cons.userImage : url.absoluteString]){error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            completion(.success(nil))
        }
        
    }
    
    func getUserBasicInfo(completion:@escaping result){
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection(Cons.user).document(userId)
        ref.getDocument { documentSnapShot, error in
            if let error = error {
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            guard let data = documentSnapShot?.data() else{return}
            let basicUser = BasicUserInfo(dict: data)
            completion(.success(basicUser))
        }
    }
    
    
    public func searchUserContacts(contacts:[ContactPresentation]){
       
    }
}
