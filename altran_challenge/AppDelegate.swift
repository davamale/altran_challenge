//
//  AppDelegate.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        prepareUI()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkManager.shared.cache.removeAllObjects()
    }
}

extension AppDelegate: Customizable {
    func prepareUI() {
        UINavigationBar.appearance().barTintColor = .defaultBlue
    }
}

