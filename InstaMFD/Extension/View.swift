//
//  View.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit

extension UIView{
    func putSubviewAt(top:NSLayoutYAxisAnchor?,
                             bottom:NSLayoutYAxisAnchor?,
                             leading:NSLayoutXAxisAnchor?,
                             trailing:NSLayoutXAxisAnchor?,
                             topDis:CGFloat,
                             bottomDis:CGFloat,
                             leadingDis:CGFloat,
                             trailingDis:CGFloat,
                             heightFloat:CGFloat?,
                             widthFloat:CGFloat?,
                             heightDimension:NSLayoutDimension?,
                             widthDimension:NSLayoutDimension?
                             ){
        translatesAutoresizingMaskIntoConstraints = false
        
        if top != nil{
            self.topAnchor
                .constraint(equalTo: top!, constant: topDis).isActive = true
        }
        if bottom != nil{
            self.bottomAnchor
                .constraint(equalTo: bottom!, constant: bottomDis).isActive = true
        }
        if leading != nil{
            self.leadingAnchor
                .constraint(equalTo: leading!, constant: leadingDis).isActive = true
        }
        if trailing != nil{
            self.trailingAnchor
                .constraint(equalTo: trailing!, constant: trailingDis
                ).isActive = true
        }
        if heightDimension != nil{
            self.heightAnchor
                .constraint(equalTo: heightDimension!).isActive = true
        }
        if widthDimension != nil{
            self.widthAnchor.constraint(equalTo: widthDimension!).isActive = true
        }
        if heightFloat != nil{
            self.heightAnchor.constraint(equalToConstant: heightFloat!).isActive = true
        }
        if widthFloat != nil{
            self.widthAnchor.constraint(equalToConstant: widthFloat!).isActive = true
        }
    
        
    }
}



