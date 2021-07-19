//
//  Singleton.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 14.07.2021.
//

import Foundation

struct Singleton{
    static var shared = Singleton()
    var dialCode:String = ""
}
