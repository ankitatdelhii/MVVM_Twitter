//
//  Tweet.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 25/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import Foundation

struct Tweet {
    
    let caption: String
    let tweetId: String
    var likes: Int
    let timestamp: Date!
    let retweetCount: Int
    let user: User
    var didLike = false
    var replyingTo: String?
    var isReply: Bool  {
        return replyingTo != nil
    }
    
    init(user: User, tweetId: String, dictData: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        self.caption = dictData["caption"] as? String ?? ""
        self.likes = dictData["likes"] as? Int ?? 0
        self.retweetCount = dictData["retweets"] as? Int ?? 0
        
        let intDate = dictData["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(floatLiteral: intDate))
        
        if let replyingTo = dictData["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
    
}
