//
//  Results.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 18.07.2021.
//

import Foundation

enum Results<Value>{
    case success(Value?)
    case failure(Error)
}
