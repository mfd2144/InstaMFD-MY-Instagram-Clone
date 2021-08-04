//
//  ContactedUserPresenatation.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 3.08.2021.
//

import Foundation



struct ContactedUserPresentation:Hashable{
    let userName:String
    let userID:String
    let url:String?
    var contactNumberOrMail:String
    
    private init(userName:String, userID:String, url:String?,contactNumberOrMail:String) {
        self.userName = userName
        self.userID = userID
        self.url = url
        self.contactNumberOrMail = contactNumberOrMail
    }
    
    init(_ data:[String:Any],userID: String , mail:Bool){
        let user = data[Cons.userName] as? String ?? "unknown user"
        let urlString = data[Cons.userImage] as? String
        let contact = mail ? data[Cons.mail] as! String : data[Cons.phone] as! String
        self.init(userName: user,userID:userID, url: urlString, contactNumberOrMail: contact)
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
    static func ==(lhs:ContactedUserPresentation,rhs:ContactedUserPresentation)->Bool{
        return lhs.userID == rhs.userID
    }
    
}
