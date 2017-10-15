//
//  LoginViewModel.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 07/10/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewModel {
    typealias CompletionHandler = (Bool, String?) -> Void
    private var user = User()
    
    var fullName: String {
        return user.fullName!
    }
    
    var email: String {
        return user.email!
    }
    
    var password: String {
        return user.password!
    }
    
    var phone: String {
        return user.phone!
    }
    
    func login(email: String, password: String, completion: @escaping CompletionHandler) -> Void {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let firebaseError = error {
                completion(false, firebaseError.localizedDescription)
                return
            }

            completion(true, nil)
        }
    }
}
