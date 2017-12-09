//
//  ProfileViewModel.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 09/12/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class ProfileViewModel {
    typealias CompletionHandler = (Bool, [String: String]) -> Void
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
    
    func getUserDetail(completion: @escaping CompletionHandler) -> Void {
        let user = Auth.auth().currentUser
        
        user?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
            if let error = error {
                completion(false, [
                    "error": error.localizedDescription
                ])
                return
            }

            let url = "https://us-central1-flutterasia-ed3d5.cloudfunctions.net/profileInfo"
            let parameters = ["token": idToken!]

            Alamofire.request(url, parameters: parameters).responseJSON { response in
                let res = response.result.value as? [String: String]
                
                completion(true, res!);
            }
        })
    }
}
