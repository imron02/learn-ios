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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    private var registerViewModel = RegisterViewModel()
    private var user = User()
    
    var changeImage: Bool = false
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewTapGesture()
        eventOnKeyboardShow()
        textFieldDelegate()
        profileImageTapGesture()
        textFieldProperties()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func textFieldDelegate() -> Void {
        // Delegate text field
        self.fullNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retypePasswordTextField.delegate = self
    }
    
    func textFieldProperties() -> Void {
        let borderWidth = CGFloat(1.0)
        let borderColor = UIColor(red: 73, green: 73, blue: 73, alpha: 1).cgColor
        let cornerRadius = CGFloat(10.0)
        
        // Set property
        fullNameTextField.layer.borderWidth = borderWidth
        fullNameTextField.layer.borderColor = borderColor
        fullNameTextField.layer.cornerRadius = cornerRadius
        
        emailTextField.layer.borderWidth = borderWidth
        emailTextField.layer.borderColor = borderColor
        emailTextField.layer.cornerRadius = cornerRadius
        
        phoneTextField.layer.borderWidth = borderWidth
        phoneTextField.layer.borderColor = borderColor
        phoneTextField.layer.cornerRadius = cornerRadius
        
        passwordTextField.layer.borderWidth = borderWidth
        passwordTextField.layer.borderColor = borderColor
        passwordTextField.layer.cornerRadius = cornerRadius
        
        retypePasswordTextField.layer.borderWidth = borderWidth
        retypePasswordTextField.layer.borderColor = borderColor
        retypePasswordTextField.layer.cornerRadius = cornerRadius
        
        profileImageView.layer.borderWidth = borderWidth
        profileImageView.layer.borderColor = borderColor
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func scrollViewTapGesture() -> Void {
        // Scroll view hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
    }
    
    func profileImageTapGesture() -> Void {
        profileImageView.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseSourcePicture))
         profileImageView.addGestureRecognizer(tap)
    }
    
    @objc func chooseSourcePicture() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.openCamera()
        }
        
        let galleryButton = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.openGallery()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel")
        }
        
        alertController.addAction(cameraButton)
        alertController.addAction(galleryButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func eventOnKeyboardShow() -> Void {
        // Move up content on keyboard show
        scrollView.contentSize = CGSize(width: 400, height: 2300)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        user.fullName = fullNameTextField.text!
        user.email = emailTextField.text!
        user.phone = phoneTextField.text!
        user.password = passwordTextField.text!
        let retypePassword = retypePasswordTextField.text!
        
        // Check empty field
        if user.fullName!.isEmpty || user.email!.isEmpty || user.phone!.isEmpty || user.password!.isEmpty || retypePassword.isEmpty {
            displayAlertMessage(message: "All field are required.")
            return
        }

        // Check password and repeat password is same
        if user.password != retypePassword {
            displayAlertMessage(message: "Password do not match")
            return
        }
        
        // Check for change image
        if !changeImage {
            displayAlertMessage(message: "Please upload image")
            return
        }
        
        // Enable overlays
        self.showOverlay("Please wait...")
        
        // Store data
        self.storeAuthData(data: user)
    }
    
    func storeAuthData(data: User) -> Void {
        registerViewModel.createUser(data: data) { (success, result) in
            if !success {
                // Dismiss overlays
                self.dismissOverlay()

                self.displayAlertMessage(message: result!)
                return
            }
            
            let profileImage = self.profileImageView.image!
            self.registerViewModel.storeImage(image: profileImage, completion: { (success, result) in
                if !success {
                    // Dismiss overlays
                    self.dismissOverlay()
                    
                    self.displayAlertMessage(message: result!)
                    return
                }
                
                let profileImageURL = result
                
                let newData: [String: String] = [
                    "fullName": self.user.fullName!,
                    "email": self.user.email!,
                    "phone": self.user.phone!,
                    "profileImageUrl": profileImageURL!
                ]
                
                self.createUserDB(data: newData)
            })
        }
    }
    
    func createUserDB(data: [String: String]) -> Void {
        let firUser = Auth.auth().currentUser!
        
        self.registerViewModel.createUserDoc(uid: firUser.uid, data: data) { (success, result) in
            // Dismiss overlays
            self.dismissOverlay()
            
            if !success {
                self.displayAlertMessage(message: result!)
            }
            
            self.displaySuccessMessage(message: result!)
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
        contentInset.bottom = keyboardFrame.size.height + 35
        scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHide() {
        scrollView.contentOffset = .zero
    }
}
