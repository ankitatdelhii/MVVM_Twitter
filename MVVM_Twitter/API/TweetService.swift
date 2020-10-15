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
    
    func uploadTweet(caption: String, config: UploadTweetConfigruation, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        
        
        switch config {
        case .tweet:
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
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            
            REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values) { (err, ref) in
                guard let replyKey = ref.key else { return }
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetId: replyKey], withCompletionBlock: completion)
            }
        }
        
        
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        guard let currentUseruid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUseruid).observe(.childAdded) { (snapshot) in
            let followigUid = snapshot.key
            
            REF_USER_TWEETS.child(followigUid).observe(.childAdded) { (snapshot) in
                print("Snapshot \(snapshot)")
                let tweetId = snapshot.key
                self.fetchTweet(withTweetId: tweetId) { (tweet) in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        
        REF_USER_TWEETS.child(currentUseruid).observe(.childAdded) { (snapshot) in
            print("Snapshot \(snapshot)")
            let tweetId = snapshot.key
            self.fetchTweet(withTweetId: tweetId) { (tweet) in
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
    
    func fetchTweet(withTweetId tweetId: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetId).observeSingleEvent(of: .value) { (tweetData) in
            let tweetId = tweetData.key
            
            guard let dataDict = tweetData.value as? [String: Any] else { return }
            guard let uid = dataDict["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetId: tweetId, dictData: dataDict)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { (tweetData) in
                guard let dataDict = tweetData.value as? [String: Any] else { return }
                guard let uid = dataDict["uid"] as? String else { return }
                let replyID = tweetData.key
                
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetId: replyID, dictData: dataDict)
                    replies.append(tweet)
                    completion(replies)
                }
            }
        }
    }
    
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetId: tweetId, dictData: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
    func fetchLikes(foruser user: User, completion: @escaping ([Tweet]) -> Void ) {
        var tweets = [Tweet]()
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { (snapshot) in
            self.fetchTweet(withTweetId: snapshot.key) { (eachTweet) in
                var mutableTweet = eachTweet
                mutableTweet.didLike = true
                tweets.append(mutableTweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes  - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            // remove like data from firebase
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).removeValue(completionBlock: completion)
            }
            
        } else {
            // add like data to firebase
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(tweet: Tweet, completion: @escaping (Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
        
    }
    

    
}
