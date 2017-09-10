//
//  FindLoveController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let firebaseError = error {
                self.displayAlertMessage(message: firebaseError.localizedDescription)
                return
            }
            
            // Update data
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            changeRequest?.photoURL = URL(string: "https://lh6.googleusercontent.com/-n7gzvVydeS8/AAAAAAAAAAI/AAAAAAAAAZs/R6peU2B6R6o/photo.jpg?sz=64")
            changeRequest?.commitChanges(completion: { (error) in
                if let changeReqError = error {
                    print(changeReqError.localizedDescription)
                    return
                }
                
                self.displaySuccessMessage(message: "Registration is successful")
            })
        }
    }
    
    override func displaySuccessMessage(message: String) {
        let alertMessage = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let btnAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) in
            // Set to main page
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            UIView.transition(from: (appDelegate.window?.rootViewController?.view)!, to: viewController.view, duration: 0.6, options: [.transitionCrossDissolve]) { (action) in
                appDelegate.window?.rootViewController = viewController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
        
        alertMessage.addAction(btnAction)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
