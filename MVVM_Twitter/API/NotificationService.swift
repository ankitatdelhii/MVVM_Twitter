//
//  NotificationService.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 04/08/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import Foundation
import Firebase

struct NotificationService {
    
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil) {
        
        print("type is \(type)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = ["timestamp" : Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetId
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else {
            
            
            
        }
        
    }
    
}
