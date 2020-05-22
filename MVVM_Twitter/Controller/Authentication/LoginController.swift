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
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_mail_outline_white_2x-1")!, textfield: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x")!, textfield: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textfield(with: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textfield(with: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let signUpBtn: UIButton = {
        let button = Utilities().buttonAttributes(textOne: "Don't have an account? ", textTwo: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCylcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Selectors
    
    @objc func handleLogin() {
        print("Login Button Tapped!")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.shared.loginUser(email: email, password: password) { (result, error) in
            if let error = error {
                print("Error Signining in \(error.localizedDescription)")
            } else {
                print("Successfully Signed In")
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                guard let rootVCRef = window.rootViewController as? MainTabBarController else { return }
                rootVCRef.authenticateUserAndConfigureUI()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleShowSignup() {
        print("Sign UP Called!")
        let signUpController = RegistrationController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    //MARK: Helper
    
    fileprivate func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150.0, height: 150.0)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(signUpBtn)
        signUpBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 8.0)
        signUpBtn.centerX(inView: view)
    }
}
