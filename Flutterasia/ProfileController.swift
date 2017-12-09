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

class ProfileController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userTableView: UITableView!
    
    var phoneNumber: String?
    var rows = ["Full name", "Email", "Phone"]
    var userValue: [String: String]?
    
    private var profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func getUser() -> Void {
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
