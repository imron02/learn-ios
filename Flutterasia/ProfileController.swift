//
//  MenuViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/18/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var activeTextField: UITextField = UITextField()
    
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
    }
    
    func getUser() -> Void {
        let user = Auth.auth().currentUser
        
        if let user = user {
            fullNameTextField.text = user.displayName
            emailTextField.text = user.email
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
