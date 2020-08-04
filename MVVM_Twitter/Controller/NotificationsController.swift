//
//  NotificationsController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

private let reuseIdentifier = "notifcationCell"

class NotificationsController: UITableViewController {
    
    //MARK: Outelets
    
    //MARK: Properties
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: Helpers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    fileprivate func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    //MARK: API
    
    func fetchNotifications() {
        NotificationService.shared.fetchNotification { (notifications) in
            self.notifications = notifications
        }
    }
    

    
    //MARK: Selectors
    
        
    
}

extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        return cell
    }
    
}
