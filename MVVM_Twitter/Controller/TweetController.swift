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
    
    private let actionSheetLauncher: ActionSheetLauncher
    
    //MARK: LifeCylcle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
        configureUI()
        fetchReplies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: API
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { (replies) in
            self.replies = replies
        }
    }
    
    //MARK: Selectors
    
    //MARK: Helper
    
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
        actionSheetLauncher.show()
    }
    
}
