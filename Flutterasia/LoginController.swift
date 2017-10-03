//
//  LoginController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/25/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBAction func unwindToLogInScreen(unwindSegue: UIStoryboardSegue) {}

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Textfield delegate
        textFieldDelegate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDelegate() -> Void {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func signinClick(_ sender: Any) {
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        
        // Check empty field
        if (userEmail?.isEmpty)! && (userPassword?.isEmpty)! {
            displayAlertMessage(message: "All field are required.")
            return
        }

        // Enable overlays
        self.showOverlay("Please wait..")
        
        
        // Check firebase data
        Auth.auth().signIn(withEmail: userEmail!, password: userPassword!) { (user, error) in
            // Dismiss overlays
            self.dismissOverlay()

            if let firebaseError = error {
                self.displayAlertMessage(message: firebaseError.localizedDescription)
                print(firebaseError.localizedDescription)
                return
            }

            // Set to main page
            let mainStoryboard = UIStoryboard(name: "Menu", bundle: nil)
            let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MenuTabbar") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            UIView.transition(from: (appDelegate.window?.rootViewController?.view)!, to: tabBarController.view, duration: 0.6, options: [.transitionCrossDissolve]) { (action) in
                appDelegate.window?.rootViewController = tabBarController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
