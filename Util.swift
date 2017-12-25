//
//  Util.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 9/2/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlertMessage(message: String) {
        let alertMessage = UIAlertController(title: "Warning",
                                             message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let btnAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alertMessage.addAction(btnAction)
        
        self.present(alertMessage, animated: true, completion: nil)
    }
}
