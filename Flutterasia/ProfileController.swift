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

class ProfileController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userTableView: UITableView!
    
    var phoneNumber: String?
    var tablewViewCount: Int = 0
    var userValue: [String: String]?
    
    //    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var phoneTextField: UITextField!
    
//    var activeTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.textFieldDelegage()
//        self.roundProfileImage()
//        self.tableViewTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getUser()
    }
//
//    func textFieldDelegage() -> Void {
//        self.fullNameTextField.delegate = self
//        self.emailTextField.delegate = self
//        self.phoneTextField.delegate = self
//    }
//
//    func roundProfileImage() -> Void {
//        profileImageView.layer.borderWidth = 1
//        profileImageView.layer.masksToBounds = false
//        profileImageView.layer.borderColor = UIColor.white.cgColor
//        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
//        profileImageView.clipsToBounds = true
//    }
//
    func getUser() -> Void {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        if let user = user {
            db.collection("users").document(user.uid).getDocument(completion: { (docSnaphot, error) in
                if let error = error {
                    self.displayAlertMessage(message: error.localizedDescription)
                    return
                }

                self.userValue = docSnaphot?.data() as? [String : String]

                self.fullNameLabel.text = self.userValue?["fullName"]
                self.phoneNumber = self.userValue?["phone"]
                self.profileImageView.loadProfileImageCache(urlString: (self.userValue?["profileImageUrl"])!)
                
                if let rows = self.userValue?.count {
                    self.tablewViewCount = rows - 1
                    self.userTableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func phoneButton(_ sender: Any) {
        guard let number = URL(string: "tel://" + phoneNumber!) else { return }
        UIApplication.shared.openURL(number)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "User Information"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablewViewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath)
        
        let userKey = Array(userValue!)[indexPath.row]
        
        cell.textLabel?.textColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1)
        cell.textLabel?.text = userKey.key
        cell.detailTextLabel?.text = userKey.value
        
        return cell
    }
    //
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.tintColor = .black
//
//        self.activeTextField = textField
//    }
//
//    func tableViewTapGesture() -> Void {
//        // Scroll view hide keyboard
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
//        tableView.addGestureRecognizer(tap)
//    }
//
//    @objc func endEditing() -> Void {
//        self.activeTextField.resignFirstResponder()
//    }
}
