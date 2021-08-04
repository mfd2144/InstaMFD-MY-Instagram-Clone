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
        guard let userId = Auth.auth().currentUser?.uid else {return completion(.failure(GeneralErrors.unspesificError("user login problem")))}
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
    
    
    public func searchUserContacts(contacts:[ContactPresentation],completion:@escaping result){
        //All phones and mails in single revelant array
        let phones = contacts.flatMap({$0.phones.compactMap{$0}})
        let mails = contacts.flatMap({$0.emails.compactMap{$0?.lowercased()}})
        var contactedResults = Array<ContactedUserPresentation>()
        
        //Firebase except max 10 values in array for search
        //part apart array according to firabase limitation then search ever user via this
        
        if  phones.count > 0{
            let phonesCons = phones.count >= 10  ? phones.count/10 : 0
            let phonesConsRemaning = phones.count - phonesCons*10
            
            
            for i in 1...phonesCons+1{
                var _phones = [String]()
                if i == phonesCons+1 || phones.count < i*10 && phonesConsRemaning > 0{
                    _phones = Array(phones[phones.count-phonesConsRemaning..<phones.count])
                }else{
                    let lastNumber = i*10
                    _phones = Array(phones[lastNumber-10..<lastNumber])
                }
                
                
                searchForUsers(isEmail: false, searchFor: _phones) { result in
                    switch result{
                    case.failure(let error):
                        completion(.failure(error))
                    case.success(let users):
                        if let users = users{
                            contactedResults = contactedResults + users
                            completion(.success(contactedResults))
                        }
                    }
                }
            }
        }
        
        
        
        if mails.count > 0{
            let mailCons = mails.count >= 10 ? mails.count/10 : 0
            let mailsConsRemaning = mails.count - mailCons*10
            
            
            for i in 1...mailCons+1{
                var _mails = [String]()
                if mailsConsRemaning > 0 || mails.count < i*10 && i == mailCons+1{
                    _mails = Array(mails[mails.count-mailsConsRemaning..<mails.count])
                }else{
                    let lastNumber = i*10
                    _mails = Array(mails[lastNumber-10..<lastNumber])
                }
    
                searchForUsers(isEmail: true, searchFor: _mails) { result in
                    switch result{
                    case.failure(let error):
                        completion(.failure(error))
                    case.success(let users):
                        if let users = users{
                            contactedResults = contactedResults + users
                            completion(.success(contactedResults))
                        }
                        
                    }
                }
            }
        }
    }
    
    
    private func searchForUsers(isEmail accodingToMails:Bool,searchFor values:[String],completion:@escaping (Results<[ContactedUserPresentation]>)->Void){
        let userRef =  Firestore.firestore().collection(Cons.user)
        var query :Query!
        var queryResults = Array<ContactedUserPresentation>()
        
        if accodingToMails {
            //search in users email
            query = userRef.whereField(Cons.mail, in: values)
            
        }else{
            //search in users phone number
            query = userRef.whereField(Cons.phone, in: values)
        }
        
        query.getDocuments { querySnapShot, error in
            if let error = error {
                completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
            }
            guard let docs = querySnapShot?.documents else { return completion(.success(queryResults))}
            
            docs.forEach { doc in
                let contactedUser = ContactedUserPresentation(doc.data(), userID: doc.documentID, mail: accodingToMails)
                queryResults.append(contactedUser)
            }
            completion(.success(queryResults))
        }
    }

    func saveOtherUsersAsFriends(_ users: Array<ContactedUserPresentation>,completion:@escaping result){
        guard let actualUser = Auth.auth().currentUser?.uid else {return}
        for (index, user) in users.enumerated(){
            
           let docRef = Firestore.firestore()
                .collection(Cons.user)
                .document(actualUser)
            .collection(Cons.friendsRef).document(user.userID)
                
            docRef.setData([Cons.userName : user.userName,
                                    Cons.userImage:user.url as Any,
                                    Cons.contactMethod :user.contactNumberOrMail,
                                    Cons.userID:user.userID
                ]) { error in
                    if let error = error {
                        completion(.failure(GeneralErrors.unspesificError(error.localizedDescription)))
                    }
                    if index == users.count-1{
                        completion(.success(nil))
                    }
                }
        }
    }
}



