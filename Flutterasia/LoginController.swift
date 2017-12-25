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
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var loginViewModel = LoginViewModel()
    private var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldDelegate()
        eventOnKeyboardShow()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func textFieldDelegate() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func processLogin() {
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
        loginViewModel.login(email: user.email!, password: user.password!) { (_, error) in
            self.dismissOverlay()
            
            if error != nil {
                self.displayAlertMessage(message: error!)
                return
            }
            
            // Set to main page
            let mainStoryboard = UIStoryboard(name: "Menu", bundle: nil)
            let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MenuTabbar")
                as? UITabBarController
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            UIView.transition(from: (appDelegate?.window?.rootViewController?.view)!,
                              to: (tabBarController?.view)!, duration: 0.6,
                              options: [.transitionCrossDissolve]) { (_) in
                                appDelegate?.window?.rootViewController = tabBarController
                                appDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func signinClick(_ sender: Any) {
        processLogin()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if textField == passwordTextField {
            processLogin()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func eventOnKeyboardShow() {
        // Move up content on keyboard show
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillBeShown),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillBeHide),
                                               name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
}
