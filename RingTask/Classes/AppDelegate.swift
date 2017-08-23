//
//  AppDelegate.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationCoordinator?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        setupWindow()
        
        if let window = window {
            appCoordinator = ApplicationCoordinator(window: window)
            appCoordinator?.start()
        }
        
        return true
    }

    // MARK: - Private methods
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
}
