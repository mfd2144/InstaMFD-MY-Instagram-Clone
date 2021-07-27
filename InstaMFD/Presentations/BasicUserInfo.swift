//
//  UserInfo.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 17.07.2021.
//

import UIKit

struct BasicUserInfo :Hashable{
    var userName:String?
    var birthdayDate:Date?
    var password:String?
    var name:String?
    var phone:String?
    var mail:String?
    var isFBAccount = false
    let following:Int
    let posts:Int
    let followers:Int
    let userImage:String?
    let createDate:Date?
   
    
    init(userName:String?,
         birtdayDate:Date?,
         name:String?,
         phone:String?,
         mail:String?,
         password:String? = nil,
         isFBAccount:Bool,
         following:Int,
         followers:Int,
         userImage:String?,
         createDate:Date? = nil,
         posts:Int) {
        self.userName = userName
        self.birthdayDate = birtdayDate
        self.name = name
        self.phone = phone
        self.mail = mail
        self.isFBAccount = isFBAccount
        self.following = following
        self.followers = followers
        self.posts = posts
        self.createDate = createDate
        self.password = password
        self.userImage = userImage
    }
    
    init(dict:Dictionary<String,Any>){
        self.userName = dict[Cons.userName] as? String
        self.birthdayDate = dict[Cons.birthday] as? Date
        self.name = dict[Cons.name] as? String
        self.phone = dict[Cons.phone] as? String
        self.mail = dict[Cons.mail] as? String
        self.isFBAccount = dict[Cons.isFBAccount] as? Bool ?? false
        self.following = dict[Cons.following] as? Int ?? 0
        self.followers = dict[Cons.follower] as? Int ?? 0
        self.posts = dict[Cons.posts] as? Int ?? 0
        self.createDate = dict[Cons.createDate] as? Date
        self.password = nil
        self.userImage = dict[Cons.userImage] as? String
    }
    
}

struct ComplexUserInfo:Hashable {
    var basicInfo:BasicUserInfo

}
