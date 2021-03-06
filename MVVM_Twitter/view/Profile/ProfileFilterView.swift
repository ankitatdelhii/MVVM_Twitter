//
//  ProfileFilterView.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 27/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

private let filterCell = "filterCell"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, didselect index: Int)
}

class ProfileFilterView: UIView {
    
    
    //MARK: Properties
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    weak var delegate: ProfileFilterViewDelegate?
    
    //MARK: LifeCylcle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Testing")
        configureUI()
    }
    
    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/3, height: 2)
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
        let selectedIndex = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .left)
    }
}


//MARK: COLLECTION VIEW Delegate and Datasource
extension ProfileFilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCell, for: indexPath) as! FilterCell
        cell.bindLabel(labelText: ProfileFilterOptions(rawValue: indexPath.row)?.description ?? "other")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let xPosition = cell.frame.origin.x
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didselect: indexPath.row)
    }
    
}

//MARK: FLOW LAYOUT DELEGATE

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
