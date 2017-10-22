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
    
    private var loginViewModel = LoginViewModel()
    private var user = User()
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func textFieldDelegate() -> Void {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func processLogin() -> Void {
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        // Check empty field
        if user.email!.isEmpty && user.password!.isEmpty {
            displayAlertMessage(message: "All field are required.")
            return
        }
        
        // Enable overlays
        self.showOverlay("Please wait..")
        
        // Check firebase data
        loginViewModel.login(email: user.email!, password: user.password!) { (success, error) in
            self.dismissOverlay()
            
            if error != nil {
                self.displayAlertMessage(message: error!)
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
    
    @IBAction func signinClick(_ sender: Any) {
        processLogin()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if (textField == passwordTextField) {
            processLogin()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
