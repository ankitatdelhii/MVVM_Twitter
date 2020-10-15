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
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { [weak self] (tweets) in
            guard let self = self else { return }
            
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedTweets() {
        self.tweets.forEach { (tweet) in
            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { (didLike) in
                guard didLike == true else { return }
                if let index = self.tweets.firstIndex(where: { $0.tweetId == tweet.tweetId }) {
                    
                    self.tweets[index].didLike = true
                }
                
            }
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
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
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
    
    //MARK: Selectors
    @objc func handleRefresh() {
        print("Wants to refresh")
        fetchTweets()
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
        let viewModel = TweetCellViewModel(tweet: tweets[indexPath.row])
        let labelHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: labelHeight + 72)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(TweetController(tweet: tweets[indexPath.row]), animated: true)
    }
}

//MARK: Tweet Cell Delegate

extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        print("Handle Like Tapped!")
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { (error, ref) in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // Upload notification if tweet is liked
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
        
    func handleProfileImageTapped(_ cell: TweetCell) {
        print("Profile Tap Handle in Feed")
        guard let user = cell.tweet?.user else { return }
        navigationController?.pushViewController(ProfileController(user: user), animated: true)
    }
    
}
