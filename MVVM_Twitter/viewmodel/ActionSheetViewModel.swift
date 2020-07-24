//
//  ActionSheetViewModel.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 25/07/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

struct ActionSheetViewModel {
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unFollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        
        return results
        
    }
    
    init(user: User) {
        self.user = user
    }
    
    
    
}


enum ActionSheetOptions {
    
    case follow(User)
    case unFollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
            
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unFollow(let user):
            return "UnFollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
    
}
