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
import FirebaseFirestore

class ProfileViewModel {
    typealias CompletionHandler = (Bool, [String: String]) -> Void
    private var user = User()
    private let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser!
    
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
    
    var localDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SS"
        return formatter
    }
    
    func getUserDetail(completion: @escaping CompletionHandler) {
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
                
                // Set user default
                if let updatedAt = res?["updatedAt"] {
                    // Server date
                    let serverDateFormatter = DateFormatter()
                    serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    serverDateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    serverDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                    let serverDate = serverDateFormatter.date(from: updatedAt)
                    
                    // Convert to local date
                    let localDateFormatter = DateFormatter()
                    localDateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let localDate = self.localDateFormatter.string(from: serverDate!)
                    
                    // Set session profile updated
                    UserDefaults.standard.set(localDate, forKey: "userUpdated")
                }
                
                completion(true, res!)
            }
        })
    }
    
    func getUserUpdated(completion: @escaping CompletionHandler) {
        let userRef = self.db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(false, [
                    "error": error.localizedDescription
                    ])
                return
            }
            
            let res = document?.data()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SS"
            
            guard let updatedAt = res?["updatedAt"] else {
                self.createUserUpdated(completion: completion)
                return
            }
            
            let dateString = dateFormatter.string(from: (updatedAt as? Date)!)
            completion(true, ["updatedAt": dateString])
        }
    }
    
    private func createUserUpdated(completion: @escaping CompletionHandler) {
        let userRef = self.db.collection("users").document(currentUser.uid)
        
        userRef.updateData([
            "updatedAt": Date(),
            "createdAt": Date()
            ], completion: { err in
                if let error = err {
                    completion(false, ["error": error.localizedDescription])
                    
                    return
                }
                
                print("success add updatedAt")
        })
    }
}
