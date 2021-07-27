//
//  AppRouter.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 9.07.2021.
//

import UIKit
import Firebase

final class AppRouter{
    var window:UIWindow?
    var scene:UIWindowScene!
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDidChangeStatus(_ :)), name: .AuthStateDidChange, object: nil)

    }

    func start(_ windowScene: UIWindowScene){
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navController = UINavigationController(rootViewController: FirstPageBuilder.make())
        navController.navigationBar.isHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    
    func startAsLoggedIn(_ windowScene: UIWindowScene){
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let newView = UserPageBuilder.make()
        let navController = UINavigationController(rootViewController: newView)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    
    func isUserLoginOrNot(_ windowScene: UIWindowScene){
       scene = windowScene
        if Auth.auth().currentUser != nil {
              startAsLoggedIn(windowScene)
        }else{
              start(windowScene)
        }

    }
    
    func startAnyNewView(_ vc:UIViewController,navControlller:Bool){
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        let view = navControlller ? UINavigationController(rootViewController: vc) : vc
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
    
   
    @objc private func userDidChangeStatus(_ responder:NSNotification){
        //for some user's process app write user document ID to singleton
        DispatchQueue.main.async { [unowned self] in
            if Auth.auth().currentUser == nil {
                  start(scene)
                FBLogOut.sharedInstance.logOut()
            }
        }
    }

}
