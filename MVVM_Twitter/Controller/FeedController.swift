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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
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
}

//MARK: Tweet Cell Delegate

extension FeedController: TweetCellDelegate {
    
    func handleProfileImageTapped() {
        print("Profile Tap Handle in Feed")
        navigationController?.pushViewController(ProfileController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
}
