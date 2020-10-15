//
//  NotificationCell.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 05/08/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    
    //MARK: Outelets
    
    //MARK: Properties
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    weak var delegate: NotificationCellDelegate?
    
    
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
    
    private lazy var followBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading...", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
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
        
        self.contentView.addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 12, paddingRight: 105)
//        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12, constant: 12)
//        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        self.contentView.addSubview(followBtn)
//        followBtn.centerY(inView: self)
        followBtn.setDimensions(width: 92, height: 32)
        followBtn.layer.cornerRadius = 32/2
        followBtn.anchor(top: topAnchor,right: rightAnchor, paddingTop: 5, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ss")
    }
    
    func configure() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        followBtn.isHidden = viewModel.shouldHideFollowBtn
        followBtn.setTitle(viewModel.followBtnText, for: .normal)
    }
    
    //MARK: Selectors
    
    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    @objc func handleFollowTapped() {
        delegate?.didTapFollow(self)
    }
    
}
