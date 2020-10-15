//
//  TweetController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 29/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

private let reusetweeCell = "tweetCell"
private let headerCell = "headerCell"

class TweetController: UICollectionViewController {
    
    
    //MARK: Properties
    private let tweet: Tweet
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
    //MARK: LifeCylcle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
        configureUI()
        fetchReplies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: API
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { (replies) in
            self.replies = replies
        }
    }
    
    //MARK: Selectors
    
    //MARK: Helper
    
    private func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
    private func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reusetweeCell)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCell)
    }
    
    
}


//MARK: CollectionView Delegate

extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusetweeCell, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
}

//MARK: CollectionView Header Delegete

extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetCellViewModel(tweet: tweet)
        let captionHeight =  viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 230)
    }
    
}

//MARK: FlowLayout Delegate

extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}


//MARK: Tweet Header Delegate

extension TweetController: TweetHeaderDelegate {
    
    
    
    func showActionSheet() {
        
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { (isFollowed) in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser:  user)
            }
        }
    }
    
}

//MARK: ActionSheetLauncher Delegate

extension TweetController: ActionSheetLauncherDelegate {
    
    func didSelect(option: ActionSheetOptions) {
        print("Selected! \(option)")
        
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                print("Followed \(user.username)")
            }
        case .unFollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                print("Unfollowed \(user.username)")
            }
        case .report:
            print("Reported User")
        case .delete:
            print("Deleted Tweet!")
        }
    }
    
}
