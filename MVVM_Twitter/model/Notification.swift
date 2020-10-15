//
//  Notification.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 04/08/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID: String?
    var timeStamp: Date!
    var user: User
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        
        if let tweetId = dictionary["tweetID"] as? String {
            self.tweetID = tweetId
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
