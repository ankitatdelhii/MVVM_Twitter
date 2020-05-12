//
//  ExploreController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class ExploreController: UIViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    fileprivate func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }

    
}
