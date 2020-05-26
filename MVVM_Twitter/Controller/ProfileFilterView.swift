//
//  ProfileFilterView.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 27/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

private let filterCell = "filterCell"

class ProfileFilterView: UIView {
    
    
    //MARK: Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: LifeCylcle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    //MARK: Selectors
    
    //MARK: Helper
    
    private func configureUI() {
        
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: filterCell)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
//        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//        collectionView.center(inView: self)
    }
}


//MARK: COLLECTION VIEW Delegate and Datasource
extension ProfileFilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCell, for: indexPath) as! FilterCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
}

//MARK: FLOW LAYOUT DELEGATE

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
