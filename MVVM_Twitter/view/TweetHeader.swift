//
//  TweetHeader.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 29/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage


class TweetHeader: UICollectionReusableView {
    
    
    //MARK: Properties
    
    var tweet: Tweet? {
        didSet {
            configureCell()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
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
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.text = "What's happening?"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .lightGray
        label.text = "6:33 PM - 1/20/2020"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "3 Retweets"
        return label
    }()
    
    private lazy var likesLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "2 Likes"
        return label
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let dividerView1 = UIView()
        dividerView1.backgroundColor = .systemGroupedBackground
        view.addSubview(dividerView1)
        dividerView1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1)
        
        let statsStack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        statsStack.axis = .horizontal
        statsStack.spacing = 12
        
        view.addSubview(statsStack)
        statsStack.centerY(inView: view)
        statsStack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let dividerView2 = UIView()
        dividerView2.backgroundColor = .systemGroupedBackground
        view.addSubview(dividerView2)
        dividerView2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1)

        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()

    
    //MARK: LifeCylcle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    
    @objc func handleProfileImageTapped() {
        print("Profile Image Tapped!")
    }
    
    @objc func showActionSheet() {
        print("Show Action Sheet")
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    //MARK: Helper
    
    private func configureUI() {
        backgroundColor = .white
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let profileStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        profileStack.spacing = 12
        profileStack.axis = .horizontal
        
        addSubview(profileStack)
        profileStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: profileStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: profileStack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, height: 40)
        
        let buttonStackView = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 72
        
        addSubview(buttonStackView)
        buttonStackView.anchor(bottom: bottomAnchor, paddingBottom: 8)
        buttonStackView.centerX(inView: self)
    }
    
    private func configureCell() {
        guard let tweet = tweet else { return }
        let viewModel = TweetCellViewModel(tweet: tweet)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
        captionLabel.text = viewModel.captionText
        dateLabel.text = viewModel.headerTimeStamp
        likesLabel.attributedText = viewModel.likesString
        retweetsLabel.attributedText = viewModel.retweetString
    }
    
}
