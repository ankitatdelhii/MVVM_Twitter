//
//  UploadTweetController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 24/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage

class UploadTweetController: UIViewController {
    
    //MARK: Properties
    private let user: User
    private let config: UploadTweetConfigruation
    
    private lazy var actionButton: UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.text = "Replying to @shdh"
        label.textColor = .lightGray
        label.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    //MARK: LifeCylcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
        case .tweet:
            print("Tweet Initialized")
        case .reply(let tweet):
            print("Reply Iniialized")
        }
    }
    
    init(user: User, config: UploadTweetConfigruation) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    //MARK: Selectors
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet() {
        print("Upload tweet now!")
        print("Tweet Config Added!")
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, config: config) { (error, result) in
            if let error = error {
                print("Error Uploading Tweet \(error.localizedDescription)")
            } else {
                print("Successfully Uploaded Tweet")
            }
        }
    }
    
    //MARK: Helper
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        //Cancel Button Nav Bar
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        //Tweet Button Nav Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
        // Profile Image
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        // Horizontal Stack View
        let horizontalStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.alignment = .leading
//        view.addSubview(horizontalStack)
        
        //Vertical Stack
        let verticalStack = UIStackView(arrangedSubviews: [replyLabel, horizontalStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 12
        
        view.addSubview(verticalStack)
        
        verticalStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        //Configuring UI
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeHolderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
}


//MARK: Model Helper
enum UploadTweetConfigruation {
    case tweet
    case reply(Tweet)
}
