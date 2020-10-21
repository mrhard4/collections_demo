//
//  AppDelegate.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 18.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        self.window = UIWindow(windowScene: UIApplication.shared.connectedScenes
                                .compactMap({ $0 as? UIWindowScene })
                                .first(where: { $0.activationState == .foregroundActive })!
        )
        self.window?.rootViewController = UINavigationController(rootViewController: RootViewController())
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

