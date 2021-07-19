//
//  File.swift
//  InstaMFDTests
//
//  Created by Mehmet fatih DOĞAN on 13.07.2021.
//

import XCTest
@testable import InstaMFD

class InstaMFDSignUpMethodTests: XCTestCase {
    private var router:MockMethodRouter!
    private var viewModel:SignUpMethodViewModel!
    private var view:MockMethodView!
    private var model:MockMethodModel!
    
    override func setUp() {
            router = MockMethodRouter()
            view = MockMethodView()
            viewModel = SignUpMethodViewModel()
            model = MockMethodModel()
        }

    func testExample() throws {
        //Given
        viewModel.delegate = view
        viewModel.router = router
        viewModel.model = model

        model.delegate = viewModel
        
        //When

        //Then
    
        
    }

}

final class MockMethodView:SignUpMethodViewModelDelegate{
    func handleOutput(_ output: SignUpMethodViewModelOutputs) {
        
    }
}

final class MockMethodRouter:SignUpMethodRouterProtocol{
    func routeToPage(_ route: SingUpMethodRoutes) {
        
    }

}


final class MockMethodModel:SignUpMethodModelProtocol{
    var delegate: SignUpMethodModelDelegate?

    func fetchCodes() {
       
    }
    
    
}
