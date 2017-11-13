//
//  MoreController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 09/11/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

class MoreController: UITableViewController {
    var viewItem = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewItem = ["Profile", "Verify", "Feedback", "Blocked List"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Hello"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
