//
//  FeedController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import SDWebImage

let tweetCell = "tweetCell"

class FeedController: UICollectionViewController {
    
    //MARK: Properties
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var user: User? {
        didSet {
            print("Got user in Feed")
            configureLeftBarButton()
        }
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    //MARK: Helper
    private func fetchTweets() {
        TweetService.shared.fetchTweets { [weak self] (tweets) in
            print("Got tweets \(tweets)")
            self?.tweets = tweets
        }
    }
    
    fileprivate func configureUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetCell)
        let image = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        image.contentMode = .scaleAspectFit
        image.setDimensions(width: 32, height: 32)
        navigationItem.titleView = image
        
        
    }
    
    fileprivate func configureLeftBarButton() {
        guard let user = user else { return }
        
        //Profile Image View
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    
}


//MARK: Delegate Datasource
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCell, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(TweetController(tweet: tweets[indexPath.row]), animated: true)
    }
}

//MARK: Tweet Cell Delegate

extension FeedController: TweetCellDelegate {
        
    func handleProfileImageTapped(_ cell: TweetCell) {
        print("Profile Tap Handle in Feed")
        guard let user = cell.tweet?.user else { return }
        navigationController?.pushViewController(ProfileController(user: user), animated: true)
    }
    
}
