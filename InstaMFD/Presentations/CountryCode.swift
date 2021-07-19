//
//  CountryCode.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 13.07.2021.
//

import Foundation

struct CountryCode:Decodable{
    let name:String
    let dialCode:String
    let isoCode: String
    let flag:URL
}
