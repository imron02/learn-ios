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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
