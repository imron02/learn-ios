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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        let user = Auth.auth().currentUser
        
        user?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
            if let error = error {
                self.displayAlertMessage(message: error.localizedDescription)
                return
            }
            
            let url = "https://us-central1-flutterasia-ed3d5.cloudfunctions.net/profileInfo"
            let parameters = ["token": idToken!]
            
            Alamofire.request(url, parameters: parameters).responseJSON { response in
                self.userValue = response.result.value as? [String: String]

                self.fullNameLabel.text = self.userValue?["Full name"]
                self.phoneNumber = self.userValue?["Phone"]
                self.profileImageView.loadProfileImageCache(urlString: (self.userValue?["profileImageUrl"])!)
                
                // Table View
                self.userTableView.reloadData()
            }
        })
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
