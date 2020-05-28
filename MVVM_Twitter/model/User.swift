//
//  User.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 24/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import Foundation
import Firebase

struct  User {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    var isFollowed = false
    
    init(uid: String, dictionary: [String : AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["userName"] as? String ?? ""
        
        guard let profileImageString = dictionary["profileImageUrl"] as? String else { return }
        self.profileImageUrl = URL(string: profileImageString)
        
    }
}
