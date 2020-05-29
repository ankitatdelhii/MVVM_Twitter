//
//  ProfileHeaderViewModel.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 27/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
    
}


struct ProfileHeaderViewModel {
    
    
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: "\(user.stats?.followers ?? 0)", text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: "\(user.stats?.following ?? 0)", text: "following")
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var fullName: String {
        return user.fullname
    }
    
    var username: String {
        return "@ \(user.username)"
    }
    
    var actionButtonTitle: String {
        // If user is current user then show edit profile else following or follow
        if user.isCurrentUser {
            return "Edit Profile"
        } else if user.isFollowed{
            return "Following"
        } else {
            return "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    private func attributedText(withValue value: String, text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(value) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedString
    }
    
}
