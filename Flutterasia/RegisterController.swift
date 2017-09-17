//
//  FindLoveController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollViewTapGesture()
        self.eventOnKeyboardShow()
        self.textFieldDelegate()
    }
    
    func textFieldDelegate() -> Void {
        // Delegate text field
        self.fullNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retypePasswordTextField.delegate = self
    }
    
    func scrollViewTapGesture() -> Void {
        // Scroll view hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
    }
    
    func eventOnKeyboardShow() -> Void {
        // Move up content on keyboard show
        scrollView.contentSize = CGSize(width: 400, height: 2300)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
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
        let authData: [String: String] = [
            "fullName": fullName,
            "email": email,
            "phone": phone,
            "password": password
        ];
        self.storeAuthData(data: authData)
    }
    
    func storeAuthData(data: [String: String]) -> Void {
        print(data)
        Auth.auth().createUser(withEmail: data["email"]!, password: data["password"]!) { (user, error) in
            if let firebaseError = error {
                print(firebaseError)
                self.displayAlertMessage(message: firebaseError.localizedDescription)
                return
            }
            
            // Get the currently signed-in user
            let user = Auth.auth().currentUser
            if let user = user {
                // Remove password value
                var users = data
                users.removeValue(forKey: "password")
                
                self.ref.child("users").child(user.uid).setValue(users, withCompletionBlock: { (error, ref) in
                    if let changeReqError = error {
                        self.displayAlertMessage(message: changeReqError.localizedDescription)
                        return
                    }
                })
                
                // Update data
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = data["fullName"]
                changeRequest?.commitChanges(completion: { (error) in
                    if let changeReqError = error {
                        self.displayAlertMessage(message: changeReqError.localizedDescription)
                        return
                    }
    
                    self.displaySuccessMessage(message: "Registration is successful")
                })
            }
            
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
        var keyboardFrame: CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHide() {
        scrollView.contentOffset = .zero
    }

}
