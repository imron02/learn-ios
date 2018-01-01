//
//  MenuViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/18/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import MessageUI

class ProfileController: UIViewController, UITextFieldDelegate,
UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userTableView: UITableView!
    
    private var phoneNumber: String?
    private var rows = ["Full name", "Email", "Phone", "Gender"]
    private var userValue: [String: String]?
    private var profileViewModel = ProfileViewModel()
    private var isLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isLoad {
            self.getUser()
        } else {
            self.isUserUpdated()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func isUserUpdated() {
        // Get updated user
        profileViewModel.getUserUpdated { (success, response) in
            if !success {
                let res = response
                self.displayAlertMessage(message: res["error"]!)
            }
            
            if let userUpdated = UserDefaults.standard.string(forKey: "userUpdated") {
                // If user already update, so get data again from server
                if userUpdated != response["updatedAt"] {
                    self.getUser()
                }
            } else {
                self.getUser()
            }
        }
    }
    
    func getUser() {
        // Show overlay
        self.showOverlay("Please wait..")
        
        profileViewModel.getUserDetail { (success, response) in
            // Dismiss overlay
            self.dismissOverlay()
            
            if !success {
                self.displayAlertMessage(message: response["error"]!)
                return
            }
            
            self.userValue = response
            
            self.fullNameLabel.text = self.userValue?["Full name"]
            self.phoneNumber = self.userValue?["Phone"]
            self.profileImageView.loadProfileImageCache(urlString: (self.userValue?["profileImageUrl"])!)
            
            // Table View
            self.userTableView.reloadData()
            
            // First load is success so set is load to true
            self.isLoad = true
        }
    }
    
    @IBAction func phoneButton(_ sender: Any) {
        guard let number = URL(string: "tel://" + phoneNumber!) else { return }
        UIApplication.shared.openURL(number)
    }
    
    @IBAction func messageButton(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = [phoneNumber!]
            composeVC.body = ""
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "User Information"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath)
        
        let key = rows[indexPath.row]
        
        cell.textLabel?.textColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1)
        cell.textLabel?.text = key
        
        if let detail = userValue?[key] {
            cell.detailTextLabel?.text = detail
        }
        
        return cell
    }
}
