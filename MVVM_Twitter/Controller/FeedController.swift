//
//  FeedController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    var user: User? {
        didSet {
            print("Got user in Feed")
            configureLeftBarButton()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    fileprivate func configureUI() {
        view.backgroundColor = .white
        let image = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        image.contentMode = .scaleAspectFit
        navigationItem.titleView = image
        
        
    }
    
    fileprivate func configureLeftBarButton() {
        guard let user = user else { return }
        
        //Profile Image View
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    
}
