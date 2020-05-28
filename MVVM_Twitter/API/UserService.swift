//
//  UserService.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 23/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import Foundation
import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String ,completion: @escaping (User) -> Void) {

        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else { return  }
            let user = User(uid: uid, dictionary: dict)
            print("User full name is \(user.fullname)")
            completion(user)
        }
        
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        
        var users = [User]()
        REF_USERS.observe(.childAdded) { (eachUserID) in
            let userId = eachUserID.key
            
            guard let dict = eachUserID.value as? [String: AnyObject] else { return  }
            let user = User(uid: userId, dictionary: dict)
            users.append(user)
            completion(users)
        }
        
        
    }
    
    func followUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUserID).updateChildValues([uid: 1]) { (error, followingResult) in
            if let error = error {
                print("Error is Following")
            } else {
                REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUserID: 1], withCompletionBlock: completion)
            }
        }
        
    }
    
    func unfollowUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUserID).child(uid).removeValue { (error, unfollowResult) in
            if let error = error {
                print("Error in unfollow \(error.localizedDescription)")
            } else {
                REF_USER_FOLLOWERS.child(uid).child(currentUserID).removeValue(completionBlock: completion)
                
            }
        }
        
    }
    
}
