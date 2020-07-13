//
//  FirstScreen.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    //MARK: PROPERTIES
    
    var user: User? {
        didSet {
            print("Got User in Main Tab")
            guard let nav = viewControllers?.first as? UINavigationController else { return }
            guard let feedVC = nav.viewControllers.first as? FeedController else { return }
            feedVC.user = user
        }
    }
    
    let actionButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.backgroundColor = .twitterBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
//        logout()
        authenticateUserAndConfigureUI()
    }
    
    //MARK: Selectors
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let controller = UploadTweetController(user: user, config: .tweet)
        let UploadTweetVC = UINavigationController(rootViewController: controller)
        UploadTweetVC.modalPresentationStyle = .fullScreen
        present(UploadTweetVC, animated: true)
    }
    
    //MARK: API
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("User NOT logged IN")
            DispatchQueue.main.async {
                let destinationVC = UINavigationController(rootViewController: LoginController())
                destinationVC.modalPresentationStyle = .fullScreen
                self.present(destinationVC, animated: true)
            }
        } else {
            print("USER LOGGED IN")
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    fileprivate func fetchUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: currentUserId) {[weak self] (user) in
            self?.user = user
        }
    }
    
    fileprivate func logout() {
        do{
            try Auth.auth().signOut()
        }
        catch let error {
            print("Error Logging Out \(error.localizedDescription)")
        }
    }
    
    
    //MARK: HELPER
    
    fileprivate func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
    }
    
    
    fileprivate func configureViewControllers() {
        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), controller: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
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


extension UIView {
    
    
    func depthFirstSearch(currentView: (UIView) -> Void) {
        
        currentView(self)
        
        self.subviews.forEach {
            $0.depthFirstSearch(currentView: currentView)
        }
        
    }
    
}
