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
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    private var registerViewModel = RegisterViewModel()
    private var user = User()
    private let genderPicker = UIPickerView()
    private let gender = ["Select", "Male", "Female"]
    
    var changeImage: Bool = false
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewTapGesture()
        textFieldDelegate()
        profileImageTapGesture()
        textFieldProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventOnKeyboardShow()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func textFieldDelegate() {
        // Delegate for picker view
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        // Delegate text field
        self.fullNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retypePasswordTextField.delegate = self
        self.genderTextField.delegate = self
        self.genderTextField.inputView = genderPicker
    }
    
    func textFieldProperties() {
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
        
        genderTextField.layer.borderWidth = borderWidth
        genderTextField.layer.borderColor = borderColor
        genderTextField.layer.cornerRadius = cornerRadius
        
        profileImageView.layer.borderWidth = borderWidth
        profileImageView.layer.borderColor = borderColor
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func scrollViewTapGesture() {
        // Scroll view hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(RegisterController.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
    }
    
    func profileImageTapGesture() {
        profileImageView.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseSourcePicture))
        profileImageView.addGestureRecognizer(tap)
    }
    
    @objc func chooseSourcePicture() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.openCamera()
        }
        
        let galleryButton = UIAlertAction(title: "Choose Photo", style: .default) { (_) in
            self.openGallery()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Cancel")
        }
        
        alertController.addAction(cameraButton)
        alertController.addAction(galleryButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func eventOnKeyboardShow() {
        // Move up content on keyboard show
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeShown),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterController.keyboardWillBeHide),
                                               name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        user.fullName = fullNameTextField.text!
        user.email = emailTextField.text!
        user.phone = phoneTextField.text!
        user.password = passwordTextField.text!
        let retypePassword = retypePasswordTextField.text!
        user.gender = genderTextField.text!.lowercased()
        
        // Check empty field
        if user.fullName!.isEmpty || user.email!.isEmpty || user.phone!.isEmpty
            || user.password!.isEmpty || retypePassword.isEmpty || gender.isEmpty {
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
    
    func storeAuthData(data: User) {
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
                    "gender": self.user.gender!,
                    "profileImageUrl": profileImageURL!
                ]
                
                self.createUserDB(data: newData)
            })
        }
    }
    
    func createUserDB(data: [String: String]) {
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
        let alertMessage = UIAlertController(title: "Success", message: message,
                                             preferredStyle: UIAlertControllerStyle.alert)
        
        let btnAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (_) in
            // Set to main page
            let tabBarStoryboard = UIStoryboard(name: "Menu", bundle: nil)
            let tabBarController = tabBarStoryboard.instantiateViewController(withIdentifier: "MenuTabbar")
                as? UITabBarController
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            UIView.transition(from: (appDelegate?.window?.rootViewController?.view)!,
                              to: (tabBarController?.view)!, duration: 0.6,
                              options: [.transitionCrossDissolve]) { (_) in
                                appDelegate?.window?.rootViewController = tabBarController
                                appDelegate?.window?.makeKeyAndVisible()
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
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}

extension RegisterController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if gender[row].lowercased() != "select" {
            self.genderTextField.text = gender[row]
            self.genderTextField.endEditing(true)
        }
    }
}
