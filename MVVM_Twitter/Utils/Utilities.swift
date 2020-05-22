//
//  Utilities.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 17/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class Utilities {
    
    
    func inputContainerView(withImage image: UIImage, textfield: UITextField) -> UIView{
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = image
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8.0, paddingBottom: 8.0)
        iv.setDimensions(width: 24.0, height: 24.0)
        
        view.addSubview(textfield)
        textfield.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8.0, paddingBottom: 8.0)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .white
        view.addSubview(underlineView)
        underlineView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8.0, paddingRight: 8.0, height: 1)
        
        return view
    }
    
    func textfield(with placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.font = UIFont.systemFont(ofSize: 16.0)
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    func buttonAttributes(textOne: String, textTwo: String) -> UIButton {
        let button = UIButton()
        let attributedString1 = NSMutableAttributedString(string: textOne, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedString1.append(NSAttributedString(string: textTwo, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedString1, for: .normal)
        return button
        
    }
    
}
