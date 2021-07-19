//
//  UserInfo.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 17.07.2021.
//

import Foundation

struct UserInfo {
    var userName:String?
    var date:Date?
    var password:String?
    var phone:String? = nil//use it as UUIDstring
    var mail:String? = nil
    var isFBAccount = false
}
