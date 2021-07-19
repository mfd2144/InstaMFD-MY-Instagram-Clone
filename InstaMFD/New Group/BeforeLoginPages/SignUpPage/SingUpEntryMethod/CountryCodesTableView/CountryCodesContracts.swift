//
//  CountryCodesContracts.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 14.07.2021.
//

import Foundation

protocol CountryCodesViewModelProtocol:AnyObject{
    var delegate:CountryCodesViewModelDelegate? {get set}
    func callMorePresentation(index:Int)
}
protocol CountryCodesViewModelDelegate:AnyObject{
    func handleOutPut(output: Results<Any>)
}
