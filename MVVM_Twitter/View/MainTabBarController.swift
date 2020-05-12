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
        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), controller: FeedController())
        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), controller: ExploreController())
        let notifications = templateNavigationController(image: UIImage(named: "like_unselected"), controller: NotificationsController())
        let conversations = templateNavigationController(image: UIImage(named: "mail"), controller: ConversationsController())        
        viewControllers = [feed, explore, notifications, conversations]
    }
    
    fileprivate func templateNavigationController(image: UIImage?, controller: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: controller)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
        
    }
    
}
