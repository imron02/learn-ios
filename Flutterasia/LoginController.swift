//
//  LoginController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/25/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBAction func unwindToLogInScreen(unwindSegue: UIStoryboardSegue) {}

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinClick(_ sender: Any) {
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        
        let userEmailStored = UserDefaults.standard.string(forKey: "userEmail")
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword")
        
        // Check empty field
        if (userEmail?.isEmpty)! && (userPassword?.isEmpty)! {
            displayAlertMessage(message: "All field are required.")
        }
        
        // Check from stored data
        if userEmail == userEmailStored && userPassword == userPasswordStored {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "isUserLogin")
        } else {
            displayAlertMessage(message: "Your username or password is wrong!")
        }
    }

}
