//
//  AppDelegate.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // Change navigation bar color
        let titleColor = UIColor(red: 184/255, green: 217/255, blue: 179/255, alpha: 1.0)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = titleColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor]
        UINavigationBar.appearance().isTranslucent = false
        
        // Change status bar color
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Set default view for logged user
        if Auth.auth().currentUser != nil {
            let menuTabbar = UIStoryboard(name: "Menu", bundle: nil)
            let tabBarController = menuTabbar.instantiateViewController(withIdentifier: "MenuTabbar")
                as? UITabBarController
            
            self.window?.rootViewController = tabBarController
            self.window?.makeKeyAndVisible()
        } else {
            let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = loginStoryboard.instantiateViewController(withIdentifier: "LoginController")
            as? LoginController
            
            self.window?.rootViewController = loginController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of
        // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits
        // the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough
        // application state information to restore your application to its current state in case it is
        // terminated later.
        // If your application supports background execution, this method is called instead of
        // applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many
        // of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }
}
