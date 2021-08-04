//
//  ImageContainer.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import UIKit.UIImage

struct ImageContainer:Hashable{
   private let id = UUID()
    let images:UIImage?
    let info:[AnyHashable:Any]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs:ImageContainer,rhs:ImageContainer)->Bool{
        return lhs.id == rhs.id
    }
    
}
