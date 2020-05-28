//
//  UserCell.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 28/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    
    //MARK: Properties
    
    var user: User? {
        didSet {
            configureCell()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let fullNameLabel: UILabel = {
       let label = UILabel()
        label.text = "fullname"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: LifeCylcle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Selectors
    
    //MARK: Helper
    
    private func configureUI(){
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let userInfoStack = UIStackView(arrangedSubviews: [usernameLabel, fullNameLabel])
        userInfoStack.axis = .vertical
        userInfoStack.spacing = 2
        
        addSubview(userInfoStack)
        userInfoStack.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    private func configureCell() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl)
        fullNameLabel.text = user.fullname
        usernameLabel.text = user.username
    }
    
}
