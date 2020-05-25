//
//  TweetService.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 24/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//
import Foundation
import Firebase


struct TweetService {
    
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { (snapshot) in
            let tweetId = snapshot.key
            
            guard let dataDict = snapshot.value as? [String: Any] else { return }
            guard let uid = dataDict["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetId: tweetId, dictData: dataDict)
                tweets.append(tweet)
                completion(tweets)
            }
            
            
        }
        
    }
    
}
