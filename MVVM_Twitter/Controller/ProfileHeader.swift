//
//  ProfileHeader.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 26/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func handleDismissal()
}

class ProfileHeader: UICollectionReusableView {
    
    
    //MARK: Properties
    
    var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var filterBar: ProfileFilterView = {
        let view = ProfileFilterView()
        view.delegate = self
        return view
    }()
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.addSubview(backbutton)
        view.backgroundColor = .twitterBlue
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        return view
    }()
    
    private lazy var backbutton: UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 30, height: 30)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80/2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let editProfileFollowButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36/2
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullNameLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.text = "Ankit Saxena"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.text = "@ankit200"
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.text = "This is the long bio text you want to add on the screen. It is enought for 3 lines i think."
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Following"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Followers"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //MARK: LifeCylcle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    //MARK: Selectors
    
    @objc func handleFollowingLabel() {
        
    }
    
    @objc func handleFollowersabel() {
        
    }
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow() {
        
    }
    
    //MARK: Helper
    private func configureUI() {
        backgroundColor = .white
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        let infoLabelStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel, bioLabel])
        infoLabelStack.axis = .vertical
        infoLabelStack.distribution = .fillProportionally
        infoLabelStack.spacing = 4
        addSubview(infoLabelStack)
        infoLabelStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/3, height: 2)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        addSubview(followStack)
        followStack.anchor(top: infoLabelStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
    }
    
    
    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
    }
    

}


//MARK: ProfileFilter View Delegate

extension ProfileHeader: ProfileFilterViewDelegate {
    
    func filterView(_ view: ProfileFilterView, didselect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) else { return }
        let xPosition = cell.frame.origin.x
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
