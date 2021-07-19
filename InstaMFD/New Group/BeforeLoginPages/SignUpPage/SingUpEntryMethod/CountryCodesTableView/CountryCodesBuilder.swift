//
//  CountryCodesBuilder.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 14.07.2021.
//


import UIKit

final class CountryBuilder{
    static func make(_ countryCodes: [CountryCode])->UIViewController{
        let view = CountryCodesView()
        let viewModel = CountryCodesViewModel()
        viewModel.countryCodes = countryCodes
        viewModel.delegate = view
        view.viewModel = viewModel
    
        return view
    }
}
