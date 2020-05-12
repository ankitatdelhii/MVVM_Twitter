//
//  FeedController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class FeedController: UIViewController {
    
    
    
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
    
    
}
