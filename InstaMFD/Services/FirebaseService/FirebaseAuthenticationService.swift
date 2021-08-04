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
    
    
    public func createNewUserWithEmail(userInfos:BasicUserInfo,completion:@escaping result){
        guard let password = userInfos.password,
              let date = userInfos.birthdayDate,
              let name = userInfos.userName,
              let mail = userInfos.mail else {
            completion(.failure(GeneralErrors.unspesificError(nil)))
            return }
        Auth.auth().createUser(withEmail: mail, password: password) {[unowned self] _, error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }else{
                addUserInformationDatabase(user: userInfos) { result in
                    completion(result)
                }
            }
        }
        
    }
    //MARK: - Phone Login
    
    public func sendVerificationNumberToPhone(_ number: (String),completion:@escaping result) {
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(SignUpMethodErrors.phoneVerificationError(error.localizedDescription)))
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(.success(nil))
        }
    }
    
    
    func checkPhoneVerificationCode(verificationCode:String, phone:PhoneNumber,completion:@escaping result){
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {return}
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let error = error {
                let newError = GeneralErrors.unspesificError(error.localizedDescription)
                completion(.failure(newError))
            }else{
                let phoneMail = "\(phone.body)@phonenumber.com"
                authResult?.user.updateEmail(to:phoneMail , completion: { error in
                    if let error = error {
                        completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
                    }
                    else{
                        completion(.success(nil))
                        
                    }
                })
            }
            
        }
    }
    
    
    func isPhoneLoginBefore(phone:PhoneNumber,completion:@escaping result){
        Firestore.firestore().collection(Cons.user).whereField(Cons.phone, isEqualTo: phone.body).getDocuments { snapShot, error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            
            if snapShot?.documents.isEmpty == false{
                completion(.success(nil))
            }else{
                completion(.failure(GeneralErrors.unspesificError("there isn't any account relevant to this number")))
            }
        }
        
        
    }
    
    
    
    
    
    //MARK: -Save user information database who sign up with phone number or facebook account
    
    public func saveUserOtherInformations(userInfos:BasicUserInfo,completion:@escaping result){
        
        guard let _ = userInfos.birthdayDate,
              let _ = userInfos.userName,
              let _ = userInfos.phone else {
            completion(.failure(GeneralErrors.unspesificError("unsufficent user model")))
            return }
        
        //Save user password for phone signup
        if let password = userInfos.password{
            Auth.auth().currentUser?.updatePassword(to:password , completion: {[unowned self] error in
                if let error = error {
                    completion(Results.failure(GeneralErrors.userSavingError(error.localizedDescription)))
                }else{
                    
                    addUserInformationDatabase(user: userInfos) { result in
                        completion(result)
                    }
                    
                }
            })
        }else{
            // this part will used for facebook login for first time
            addUserInformationDatabase(user: userInfos ) { result in
                completion(result)
            }
        }
    }
    
    
    private func addUserInformationDatabase(user:BasicUserInfo,completion:@escaping result){
        guard let name = user.userName,
              let date = user.birthdayDate else {return completion(.failure(GeneralErrors.unspesificError("Adding user information to db failure")))}
       
        let createDate =  user.createDate ?? Date()
        
        guard let docID = Auth.auth().currentUser?.uid else {return completion(.failure(GeneralErrors.unspesificError("Unknown error")))}
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
                    Cons.userImage:user.userImage as Any,
                    Cons.createDate:createDate,
                    Cons.follower:user.followers,
                    Cons.following :user.following,
                    Cons.isFBAccount: user.isFBAccount,
                    Cons.posts :user.posts,
                    Cons.name: user.name as Any,
                    Cons.mail:user.mail as Any,
                    Cons.phone :user.phone as Any,
                    
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
            var userImage: String?
            if let imageUrl = authResult?.user.photoURL{
                userImage = imageUrl.absoluteString
            }
            
            let userInfo = BasicUserInfo(userName: name, birtdayDate: nil, name: nil, phone: nil, mail: docID, password: nil, isFBAccount: true, following: 0, followers: 0, userImage: userImage, createDate:Date(), posts: 0 )
            checkFBUserLoginBefore(userInfo: userInfo) { result in
                completion(result)
            }
        }
    }
    
    
    private func checkFBUserLoginBefore(userInfo: BasicUserInfo,completion:@escaping result){
        guard let docID = userInfo.mail else {return}
        
        let collectionPath = Firestore.firestore().collection(Cons.user)
        let query = collectionPath.whereField(FieldPath.documentID(), isEqualTo: docID)
        query.getDocuments { querySnapShot, error in
            
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            if  querySnapShot?.documents.first != nil {
                //user login before
                completion(.success(nil))
            }else{
                completion(.success(userInfo))
            }
        }
    }
    
    public func addFBUserInfo(userInfo:BasicUserInfo,completion:@escaping result){
        
        guard let id = Auth.auth().currentUser?.uid,
              let name = userInfo.userName,
              let date = userInfo.birthdayDate else {
            completion(.failure(GeneralErrors.unspesificError("unsufficient data")))
            return
        }
        let collectionPath = Firestore.firestore().collection(Cons.user)
        
        
        collectionPath
            .document(id)
            .setData([
                Cons.userName : name,
                Cons.birthday: date,
                Cons.userImage:userInfo.userImage as Any,
                Cons.createDate:Date(),
                Cons.follower:userInfo.followers,
                Cons.following :userInfo.following,
                Cons.isFBAccount: userInfo.isFBAccount,
                Cons.posts :userInfo.posts,
                Cons.name: userInfo.name as Any,
                Cons.mail:NSNull(),
                Cons.phone :userInfo.phone as Any,
                
            ]){ error in
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
    
    //MARK: -
    
    public func sendEmailPasswordReset(email:String,completion:@escaping result){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error{
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }else{
                completion(.success(nil))
            }
        }
        
    }
    
    private func createSubFolder(userUID:String,completion:result){
        
        
        
        
        
    }
    
}

