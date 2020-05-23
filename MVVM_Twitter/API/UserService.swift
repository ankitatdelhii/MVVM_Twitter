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
    
    func fetchUser(completion: @escaping (User) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else { return  }
            let user = User(uid: uid, dictionary: dict)
            print("User full name is \(user.fullname)")
            completion(user)
        }
        
    }
    
}
