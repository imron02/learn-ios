//
//  MenuViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/18/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var activeTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldDelegage()
        self.roundProfileImage()
        self.tableViewTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getUser()
    }
    
    func textFieldDelegage() -> Void {
        self.fullNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneTextField.delegate = self
    }
    
    func roundProfileImage() -> Void {
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2 
        profileImageView.clipsToBounds = true
    }
    
    func getUser() -> Void {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user {
            db.collection("users").document(user.uid).getDocument(completion: { (docSnaphot, error) in
                if let error = error {
                    self.displayAlertMessage(message: error.localizedDescription)
                    return
                }
                
                let value = docSnaphot?.data()
                
                self.fullNameTextField.text = value?["fullName"] as? String
                self.emailTextField.text = value?["email"] as? String
                self.phoneTextField.text = value?["phone"] as? String
                
                self.profileImageView.loadProfileImageCache(urlString: (value?["profileImageUrl"] as! String))
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .black
        
        self.activeTextField = textField
    }
    
    func tableViewTapGesture() -> Void {
        // Scroll view hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func endEditing() -> Void {
        self.activeTextField.resignFirstResponder()
    }
}
