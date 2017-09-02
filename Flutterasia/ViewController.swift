//
//  ViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLogin")
        
        // Set to login page
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(from: (appDelegate.window?.rootViewController?.view)!, to: loginController.view, duration: 0.6, options: [.transitionCrossDissolve]) { (action) in
            appDelegate.window?.rootViewController = loginController
            appDelegate.window?.makeKeyAndVisible()
        }
        
//        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
}

