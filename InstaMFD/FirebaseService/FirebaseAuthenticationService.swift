//
//  FirebaseAuthenticationService.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation
import Firebase
import FBSDKLoginKit

final class FirebaseAuthenticationService{
    typealias result = (Results<Any>)->Void
    
    public func signIn(emailOrPhoneNumber:String,Password:String,completion: @escaping result){
        Auth.auth().signIn(withEmail: emailOrPhoneNumber, password: Password) { _, error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }else{
                completion(.success(nil))
            }
            
        }
    }
    
    public func createNewUserWithEmail(userInfos:UserInfo,completion:@escaping result){
        guard let password = userInfos.password,
              let date = userInfos.date,
              let name = userInfos.userName,
              let mail = userInfos.mail else {
            completion(.failure(GeneralErrors.unspesificError(nil)))
            return }
        Auth.auth().createUser(withEmail: mail, password: password) {[unowned self] _, error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }else{
                addUserInformationDatabase(name: name, date: date, docID: mail) { result in
                    completion(result)
                }
            }
        }
        
    }
    
    //MARK: -Save user information database who sign up with phone number or facebook account
    
    public func saveUserOtherInformations(userInfos:UserInfo,completion:@escaping result){
        
        guard let date = userInfos.date,
              let name = userInfos.userName,
              let phone = userInfos.phone else {
            completion(.failure(GeneralErrors.unspesificError(nil)))
            return }
        
        //Save user password for phone signup
        if let password = userInfos.password{
            Auth.auth().currentUser?.updatePassword(to:password , completion: {[unowned self] error in
                if let error = error {
                    completion(Results.failure(GeneralErrors.userSavingError(error.localizedDescription)))
                }else{
                    
                    addUserInformationDatabase(name: name, date: date, docID: phone) { result in
                        completion(result)
                    }
                    
                }
            })
        }else{
            // this part will used for facebook login for first time
            addUserInformationDatabase(name: name, date: date, docID: phone) { result in
                completion(result)
            }
        }
    }
    
    
    

    
    private func addUserInformationDatabase(name:String,date:Date,docID:String,completion:@escaping result){
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = name
        request?.commitChanges(completion: { error in
            if let error = error {
                completion(Results.failure(GeneralErrors.userSavingError(error.localizedDescription)))
            }else{
                //Save some user info to firestore dynamic database
                let doc = Firestore.firestore().collection(Cons.user).document(docID)
                doc.setData([
                    Cons.userName : name,
                    Cons.birthday: date,
                    Cons.userImage:NSNull(),
                    
                ]) { error in
                    if let error = error{
                        completion(Results.failure(GeneralErrors.userSavingError(error.localizedDescription)))
                    }else{
                        completion(Results.success(nil))
                    }
                }
            }
            
        })
    }
    
 
    
    //MARK: - Facebook login
    
    public func loginWithFB(completion:@escaping result){
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) {[unowned self ] authResult, error in
            if let error = error {
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            let name = authResult?.user.displayName ?? "fbUser-\(String(authResult!.user.uid))"
            //            let mail = authResult?.additionalUserInfo?.profile
            let docID = authResult?.user.uid
            let userInfo = UserInfo(userName:name , date: nil, password: nil, phone: docID, mail: nil, isFBAccount: true)
            checkFBUserLoginBefore(userInfo: userInfo) { result in
                completion(result)
            }
        }
    }
    private func checkFBUserLoginBefore(userInfo: UserInfo,completion:@escaping result){
        guard let docID = userInfo.phone else {return}
        
        let collectionPath = Firestore.firestore().collection(Cons.user)
        let query = collectionPath.whereField(FieldPath.documentID(), isEqualTo: docID)
        query.getDocuments { querySnapShot, error in
            
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            if  querySnapShot?.documents.first != nil {
                //user login before
                completion(.success(nil))
                return
            }else{
                completion(.success(userInfo))
            }
                }
        }
    
    public func addFBUserInfo(userInfo:UserInfo,completion:@escaping result){
        
            guard let id = userInfo.phone,
                  let name = userInfo.userName,
                  let date = userInfo.date else {
                completion(.failure(GeneralErrors.unspesificError("unsufficient data")))
                return
            }
        let collectionPath = Firestore.firestore().collection(Cons.user)
        
        collectionPath
            .document(id)
            .setData([
                        Cons.userName : name,
                        Cons.birthday: date,
                        Cons.userImage:NSNull()]){ error in
                if let error = error{
                    completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
                }else{
                    completion(.success(nil))
                }
            }
    }

    //MARK: - Sign out
    public func signOut()throws{
        try Auth.auth().signOut()
    }
    
}


