//
//  MenuViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/18/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UITableViewController {
    
    @IBOutlet weak var displayNameCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUser()
    }
    
    func getUser() -> Void {
        let user = Auth.auth().currentUser
        
        if let user = user {
//            print(user.displayName as String!)
            displayNameCell.detailTextLabel?.text = user.displayName
            emailCell.detailTextLabel?.text = user.email
        }
    }
}
