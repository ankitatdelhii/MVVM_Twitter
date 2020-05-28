//
//  ExploreController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

let reuseCell = "userCell"

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

//MARK: Table View Delegate

//extension ExploreController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath)
//        return cell
//    }
//
//}
