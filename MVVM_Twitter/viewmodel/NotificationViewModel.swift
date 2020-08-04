//
//  NotificationViewModel.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 05/08/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timeStampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timeStamp, to: Date()) ?? "2m"
    }
    
    var notificationMessage: String {
        switch type {
   
        case .follow:
            return " started following you"
        case .like:
            return " liked your tweet"
        case .reply:
            return " replied to your tweet"
        case .retweet:
            return " retweeted your tweet"
        case .mention:
            return " mentioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timeStamp = timeStampString else { return nil}
        
        let title = NSMutableAttributedString(string: user.username, attributes: [.font: UIFont.systemFont(ofSize: 12)])
        title.append(NSAttributedString(string: notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        title.append(NSAttributedString(string: " ·\(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
    
}
