//
//  FindLoveController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scroll view hide keyboar
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        // Move up content on keyboard show
        scrollView.contentSize = CGSize(width: 400, height: 2300)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        // Delegate text field
        textFieldDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDelegate() -> Void {
        self.fullNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retypePasswordTextField.delegate = self
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
    
    func displaySuccessMessage(message: String) {
        let alertMessage = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let btnAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) in
            // Set to main page
            let tabBarStoryboard = UIStoryboard(name: "Menu", bundle: nil)
            let tabBarController = tabBarStoryboard.instantiateViewController(withIdentifier: "MenuTabbar") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            UIView.transition(from: (appDelegate.window?.rootViewController?.view)!, to: tabBarController.view, duration: 0.6, options: [.transitionCrossDissolve]) { (action) in
                appDelegate.window?.rootViewController = tabBarController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
        
        alertMessage.addAction(btnAction)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHide() {
        scrollView.contentOffset = .zero
    }

}
