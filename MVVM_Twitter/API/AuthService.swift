//
//  AuthService.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 22/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredectials{
    
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
    
}


struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredectials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let name = credentials.fullName
        let userName = credentials.userName
        
        guard let userImageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let profileImgFileName = NSUUID().uuidString
        
        let storageRef = STORAGE_PROFILE_IMAGES.child(profileImgFileName)
        
        storageRef.putData(userImageData, metadata: nil) { (imageMetaData, error) in
            if let error = error {
                print("Error Uploading Image \(error.localizedDescription)")
            } else {
                print("Successfully Uploaded Image")
                storageRef.downloadURL { (imageUrl, error) in
                    guard let profileImgDownloadUrl = imageUrl?.absoluteString else { print("No download url"); return }
                    
                    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                        if let error = error {
                            print("Error Registering User \(error.localizedDescription)")
                        } else {
                            guard let uid = authResult?.user.uid else{ return }
                            let userData = ["email": email, "userName": userName, "fullName": name, "profileImageUrl": profileImgDownloadUrl]
                            
                            REF_USERS.child(uid).updateChildValues(userData, withCompletionBlock: completion)
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}
