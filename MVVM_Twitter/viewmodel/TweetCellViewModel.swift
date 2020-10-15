//
//  TweetCellViewModel.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 26/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

struct TweetCellViewModel {
    
    //MARK: Init Properties
    let tweet: Tweet
    let user: User
    
    //MARK: Properties
    var captionText: String {
        return tweet.caption
    }
    
    var profileImageUrl: URL? {
        return tweet.user.profileImageUrl
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: tweet.timestamp, to: Date()) ?? "2m"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm: a · MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var userInfo: NSAttributedString {
        
        let title = NSMutableAttributedString(string: tweet.user.fullname, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(tweet.user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ·\(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    var replyText: String {
        return "→ replying to @\(tweet.replyingTo ?? "")"
    }
    
    var retweetString: NSAttributedString {
        return attributedText(withValue: "\(tweet.retweetCount )", text: "retweets")
    }
    
    var likesString: NSAttributedString {
        return attributedText(withValue: "\(tweet.likes)", text: "likes")
    }
    
    
    
    var fullName: String {
        return tweet.user.fullname
    }
    
    var username: String {
        return "@ \(tweet.user.username)"
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    //MARK: HELPER
    
    private func attributedText(withValue value: String, text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(value) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedString
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        let size = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
    
}
