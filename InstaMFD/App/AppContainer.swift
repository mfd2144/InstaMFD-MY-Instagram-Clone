//
//  AppContainer.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import Foundation


let appContainer = AppContainer()


final class AppContainer{
    let router = AppRouter()
    
    let authService = FirebaseAuthenticationService()
    let userService = FirebaseUserServices()
    let photoDownloader = PhotoDownloader()
    
}
