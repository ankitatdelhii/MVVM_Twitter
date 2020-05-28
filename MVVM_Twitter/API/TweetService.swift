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
        
        let tweetID = REF_TWEETS.childByAutoId()
        
        tweetID.updateChildValues(values) { (error, result) in
            if let error = error {
                print("Error Uploading tweet \(error.localizedDescription)")
            } else {
                guard let tweetID = tweetID.key else { return }
                // Making Another Data Structure to hold all tweet ids of user
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        }
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
    
    func fetchTweets(user: User, completion: @escaping ([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        let uid = user.uid
        REF_USER_TWEETS.child(uid).observe(.childAdded) { (tweetID) in
            
            let tweetID = tweetID.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (tweetData) in
                let tweetId = tweetData.key
                
                guard let dataDict = tweetData.value as? [String: Any] else { return }
                guard let uid = dataDict["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetId: tweetId, dictData: dataDict)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }

            
            
            
        }
        
        
    }
    
}
