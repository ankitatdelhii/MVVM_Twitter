//
//  CaptionTextView.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 24/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class CaptionTextView: UITextView {
    
    //MARK: Properties
    let placeHolderLabel: UILabel = {
        let placeHolder = UILabel()
        placeHolder.backgroundColor = .white
        placeHolder.text = "What's happening?"
        placeHolder.font = UIFont.systemFont(ofSize: 16)
        placeHolder.textColor = .gray
        return placeHolder
    }()
    
    //MARK: LifeCylcle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Selectors
    @objc func handleTextInputChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
    //MARK: Helper

    
    
}
