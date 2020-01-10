//
//  AppDelegate.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/18/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UITabBar.appearance().tintColor = .green
        UITabBar.appearance().unselectedItemTintColor = .blue
        return true
    }
}

