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
        // Override point for customization after application launch.
        
        NetworkManager.get(url: URL(string: Constants.Routes.gnomeInfo)!) { (json, error) in
            
            guard let gnomeList = json else {
                return
            }
            
            for gnome in gnomeList {
                if let gnomeObject = Gnome.save(object: gnome) {
                    
                }
            }
        }
        
        return true
    }
}

