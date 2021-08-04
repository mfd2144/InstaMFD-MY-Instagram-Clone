//
//  UserDataItems.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation

enum  UserDataItems:Hashable{
    case user(BasicUserInfo)
    case story(Story)
    case photo(Photo)
}
