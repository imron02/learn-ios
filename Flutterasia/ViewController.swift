//
//  ViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 8/16/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLogin")
        
        if !isUserLoggedIn {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLogin")
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
}

