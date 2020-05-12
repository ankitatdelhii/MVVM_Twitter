//
//  FirstScreen.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: PROPERTIES
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        
    }
    
    //MARK: HELPER
    fileprivate func configureViewControllers() {
        let feed = FeedController()
        feed.tabBarItem.image = UIImage(named: "home_unselected")
        let explore = ExploreController()
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        let notifications = NotificationsController()
        notifications.tabBarItem.image = UIImage(named: "like_unselected")
        let conversations = ConversationsController()
        conversations.tabBarItem.image = UIImage(named: "mail")
        
        viewControllers = [feed, explore, notifications, conversations]
    }
    
}
