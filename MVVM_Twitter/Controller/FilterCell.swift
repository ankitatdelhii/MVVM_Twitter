//
//  FilterCell.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 27/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    
    //MARK: Properties
    
    private let titleLabel: UILabel =  {
       let label = UILabel()
//        label.textAlignment = .center
        label.backgroundColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test Filter"
        label.textColor = .lightGray
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.font = UIFont.systemFont(ofSize: 16)
                titleLabel.textColor = .twitterBlue
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                titleLabel.textColor = .lightGray
            }
        }

    }
    
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
        backgroundColor = .cyan
        addSubview(titleLabel)
//        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        titleLabel.center(inView: self)
    }
    
}
