//
//  FilteredImageContainer.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 5.08.2021.
//

import Foundation

struct FilteredImageContainer:Hashable{
    let name:String
    let container:ImageContainer
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs:FilteredImageContainer,rhs:FilteredImageContainer)->Bool{
        return lhs.name == rhs.name
    }
}
