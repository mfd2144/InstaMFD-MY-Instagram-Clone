//
//  InstaMFDTests.swift
//  InstaMFDTests
//
//  Created by Mehmet fatih DOĞAN on 8.07.2021.
//

import XCTest
@testable import InstaMFD

class InstaMFDLoginViewTests: XCTestCase {
    private var router:LoginRouterProtocol!
    private var viewModel:LoginViewModelProtocol!
    private var view:MockView!
    
    override func setUp() {
            router = MockRouter()
            viewModel = LoginViewModel()
            view = MockView()
        }

    func testExample() throws {
        //Given
        viewModel.delegate = view
        //When
        viewModel.logIn("ali", "1234")
        //Then
    
    }

}



final class MockView:LoginViewModelDelegate{
    var outputs:[LoginModelOutputs] = []
    
    func handleModelOutputs(_ output: LoginModelOutputs) {
        outputs.append(output)
    }
}

final class MockRouter:LoginRouterProtocol{
    func routeToPage(_ page: LoginRoutes) {
        
    }
    
    func routeToSingUp() {
        
    }
    
    func routeToForgetPassword(_ userName: String?) {
        
    }
    
    
}
