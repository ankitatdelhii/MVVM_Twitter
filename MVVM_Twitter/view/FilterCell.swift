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
        label.font = UIFont.systemFont(ofSize: 14)
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
        print("Testing init")
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    //MARK: Selectors
    
    //MARK: Helper
    
    private func configureUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    func bindLabel(labelText: String) {
        titleLabel.text = labelText
    }
    
}
