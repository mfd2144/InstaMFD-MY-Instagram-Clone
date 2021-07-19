//
//  AlertView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 16.07.2021.
//

import UIKit



final class AddAnySimpleCaution:UIAlertController{
   
    convenience init(title:String,message:String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction()
    }
    private func addAction(){
        let action = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        addAction(action)
    }
}
