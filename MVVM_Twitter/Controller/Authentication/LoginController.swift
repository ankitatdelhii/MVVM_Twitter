//
//  LoginController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 17/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: Properties
    
    private lazy var logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
       let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        view.backgroundColor = .blue
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "ic_mail_outline_white_2x-1")
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8.0, paddingRight: 8.0)
        iv.setDimensions(width: 24.0, height: 24.0)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
       let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        view.backgroundColor = .red
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "ic_lock_outline_white_2x")
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8.0, paddingRight: 8.0)
        iv.setDimensions(width: 24.0, height: 24.0)
        
        return view
    }()
    
    //MARK: LifeCylcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Selectors
    
    //MARK: Helper
    
    fileprivate func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150.0, height: 150.0)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100.0)
    }
}
