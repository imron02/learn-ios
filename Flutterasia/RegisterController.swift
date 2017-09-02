//
//  FindLoveController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let fullName = fullNameTextField.text!
        let email = emailTextField.text!
        let phone = phoneTextField.text!
        let password = passwordTextField.text!
        let retypePassword = retypePasswordTextField.text!
        
        // Check empty field
        if fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || retypePassword.isEmpty {
            displayAlertMessage(message: "All field are required.")
            return
        }
        
        // Check password and repeat password is same
        if password != retypePassword {
            displayAlertMessage(message: "Password do not match")
            return
        }
        
        // Store data
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
        
        displaySuccessMessage(message: "Registration is successful")
    }

}
