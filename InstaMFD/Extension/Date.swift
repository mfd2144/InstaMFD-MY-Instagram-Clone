//
//  Date.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import Foundation

extension Date{
    static func dateString(date:Date=Date())->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
