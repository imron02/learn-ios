//
//  ViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        let displayName = user?.displayName
        
        if user != nil {
            welcomeLabel.text = "Welcome \(displayName!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        // Firebase logout
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            // Set to login page
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = loginStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            UIView.transition(from: (appDelegate.window?.rootViewController?.view)!, to: loginController.view, duration: 0.6, options: [.transitionCrossDissolve]) { (action) in
                appDelegate.window?.rootViewController = loginController
                appDelegate.window?.makeKeyAndVisible()
            }
        } catch let signOutError as NSError {
            self.displayAlertMessage(message: signOutError.localizedDescription)
        }
//        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
}

