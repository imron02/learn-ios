//
//  RegisterViewModel.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 15/10/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegisterViewModel {
    typealias CompletionHandler = (Bool, String?) -> Void
    private var user = User()
    private let db = Firestore.firestore()
    
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
    
    func createUser(data: User, completion: @escaping CompletionHandler) {
        Auth.auth().createUser(withEmail: data.email!, password: data.password!) { (_, error) in
            if let firebaseError = error {
                completion(false, firebaseError.localizedDescription)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func storeImage(image: UIImage, completion: @escaping CompletionHandler) {
        let storageRef = Storage.storage().reference()
        let imageName = NSUUID().uuidString
        let imageRef = storageRef.child("profileImages/\(imageName).png")
        let uploadImage = UIImagePNGRepresentation(image)!
        
        imageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
            if let firebaseError = error {
                print(firebaseError.localizedDescription)

                completion(false, "Failed upload image.")

                // Sign out user
                do {
                    try Auth.auth().signOut()
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
                return
            }

            let imageURL = metadata!.downloadURL()!.absoluteString
            completion(true, imageURL)
        })
    }
    
    func createUserDoc(uid: String, data: [String: String], completion: @escaping CompletionHandler) {
        db.collection("users").document(uid).setData(data) { (error) in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            // Update data
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = data["fullName"]
            changeRequest?.commitChanges(completion: { (error) in
                if let changeReqError = error {
                    completion(false, changeReqError.localizedDescription)
                    return
                }
                
                completion(true, "Registration is successful")
            })
        }
    }
}
