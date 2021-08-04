//
//  UserPage.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 29.07.2021.
//

import Foundation
enum UserPageSection:Int,CaseIterable{
    case user
    case story
    case photo
    var cellIdentifier:String{
        switch self {
        case .photo:
            return "PhotoCell"
        case.story:
            return "StoryCell"
        case .user:
            return "UserCell"
        }
    }
}
