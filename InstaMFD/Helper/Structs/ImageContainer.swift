//
//  ImageContainer.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import UIKit.UIImage
import CoreLocation

struct ImageContainer:Hashable{
   private let id = UUID()
    let images:UIImage?
    let info:[AnyHashable:Any]?
    var location:CLLocationCoordinate2D?
    var tags:[TaggedUser]?
    var comment:String?
    
    
    init(images:UIImage?, info:[AnyHashable:Any]?, location:CLLocationCoordinate2D? = nil,tags:[TaggedUser]? = nil ,comment:String? = nil ){
        self.comment = comment
        self.tags = tags
        self.location = location
        self.images = images
        self.info = info
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs:ImageContainer,rhs:ImageContainer)->Bool{
        return lhs.id == rhs.id
    }
    
}

struct TaggedUser {
    let userName:String
    let userImage:String
    let userID:String
    let name:String?
}

