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
    
    var activeTextField: UITextField = UITextField()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldDelegage()
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
    
    func getUser() -> Void {
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        if let user = user {
            self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                self.fullNameTextField.text = value?["fullName"] as? String
                self.emailTextField.text = value?["email"] as? String
                self.phoneTextField.text = value?["phone"] as? String
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
