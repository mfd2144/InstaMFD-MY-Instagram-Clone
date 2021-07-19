//
//  PhoneNumber.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

struct PhoneNumber:Equatable{
    let code:String
    let body:String
    var copleteNumber:String{
        get {
            return code+body
        }
    }
 
}
