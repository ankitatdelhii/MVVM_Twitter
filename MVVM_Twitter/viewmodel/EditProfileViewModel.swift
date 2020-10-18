//
//  EditProfileViewModel.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 18/10/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case userName
    case bio
    
    var description: String {
        switch self {
        case .fullName:
            return "Name"
        case .userName:
            return "UserName"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    //MARK: Init Properties
    let option: EditProfileOptions
    let user: User
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTexView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != nil
    }
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        
        case .fullName:
            return user.fullname
        case .userName:
            return user.username
        case .bio:
            return user.bio
        }
    }
    
}
