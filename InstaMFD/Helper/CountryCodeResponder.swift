//
//  CountryCodeResponder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 13.07.2021.
//

import Foundation

enum RootCodingKey:String,CodingKey{
case data
}


public struct CountryCodeResponse:Decodable{
    var results:[CountryCode]
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKey.self)
        results = try rootContainer.decode([CountryCode].self, forKey: .data)
    }
}
