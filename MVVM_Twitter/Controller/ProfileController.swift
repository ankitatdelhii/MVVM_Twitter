//
//  ProfileController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 26/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

private let profileTweetCell = "profileTweetCell"
private let profileHeaderCell = "profileHeaderCell"

class ProfileController: UICollectionViewController {
    
    //MARK: Properties
    var user: User
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: LifeCylcle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Selectors
    
    
    //MARK: API
    private func fetchTweets() {
        TweetService.shared.fetchTweets(user: user) {[weak self] (tweets) in
            print("Tweets are \(tweets)")
            self?.tweets = tweets
        }
    }
    
    //MARK: Helper
    
    private func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: profileTweetCell)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderCell)
    }
    
}

//MARK: CollectionView Delegate

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileTweetCell, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
}

//MARK: CollectionView Header Delegete

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderCell, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
}

//MARK: FlowLayout Delegate

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

//MARK: Profile Dismiss Delegate

extension ProfileController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeader) {
        let currentTwitterUserID = user.uid
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: currentTwitterUserID) { (error, result) in
                if let error = error {
                    print("error in follow \(error.localizedDescription)")
                } else {
                    self.user.isFollowed = false
                    print("Successfully Unfollowed")
                }

            }
        } else {
            UserService.shared.followUser(uid: currentTwitterUserID) { (error, result) in
                if let error = error {
                    print("error in follow \(error.localizedDescription)")
                } else {
                    self.user.isFollowed = true
                    print("Successfully Followed")
                }
            }
        }
        
        
    }
    
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
}
