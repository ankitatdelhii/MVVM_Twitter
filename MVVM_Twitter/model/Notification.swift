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
    let tweetID: String?
    var timeStamp: Date!
    let user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
