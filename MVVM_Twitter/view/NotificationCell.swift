//
//  NotificationCell.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 05/08/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    
    //MARK: Outelets
    
    //MARK: Properties
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let notificationLabel: UILabel =  {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some Notif text"
        return label
    }()
    
    //MARK: Helpers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12, constant: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ss")
    }
    
    func configure() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
    }
    
    //MARK: Selectors
    
    @objc func handleProfileImageTapped() {
        
    }
    
}
