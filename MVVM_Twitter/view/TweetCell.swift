//
//  TweetCell.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 25/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    //MARK: Properties
    
    weak var delegate: TweetCellDelegate?
    
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
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.text = "What's happening?"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .white
        label.text = "Eddie Brock @bdjds"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray

        return label
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
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    
    //MARK: Selectors
    
    @objc func handleProfileImageTapped() {
        print("Profile Image Tapped!")
        delegate?.handleProfileImageTapped(self)
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
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        let infoStackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.distribution = .fillProportionally
        addSubview(infoStackView)
        infoStackView.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        let buttonStackView = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 72
        
        addSubview(buttonStackView)
//        buttonStackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 8)
        buttonStackView.anchor(bottom: bottomAnchor, paddingBottom: 8)
        buttonStackView.centerX(inView: self)
    }
    
    private func configureCell() {
        
        guard let tweet = tweet else { return }
        let viewModel = TweetCellViewModel(tweet: tweet)
        
        captionLabel.text = viewModel.captionText
        infoLabel.attributedText = viewModel.userInfo
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
    }
        
}
