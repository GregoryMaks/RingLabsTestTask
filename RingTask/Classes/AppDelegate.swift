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
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        setupWindow()
        
        if let window = window {
            appCoordinator = ApplicationCoordinator(window: window)
            appCoordinator?.start()
        }
    }

    // MARK: - Private methods
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
}
