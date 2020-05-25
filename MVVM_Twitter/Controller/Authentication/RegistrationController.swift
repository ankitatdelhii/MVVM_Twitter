//
//  RegistrationController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 17/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    
    //MARK: Properties
    
    private var profileImage: UIImage?
    
    private lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        return ip
    }()
    
    private lazy var uploadImageBtn: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(profilePicTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_mail_outline_white_2x-1")!, textfield: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x")!, textfield: passwordTextField)
        return view
    }()
    
    private lazy var nameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_mail_outline_white_2x-1")!, textfield: nameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x")!, textfield: usernameTextField)
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
    
    private let nameTextField: UITextField = {
        let tf = Utilities().textfield(with: "Full Name")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textfield(with: "Username")
        return tf
    }()
    
    private let signUpBtn: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let logInBtn: UIButton = {
        let button = Utilities().buttonAttributes(textOne: "Already have an account? ", textTwo: "Log In")
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCylcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Selectors
    
    @objc func handleLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Signup
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        guard let userName = usernameTextField.text else{ return }
        guard let userImage = profileImage else { return }
        
        let creds = AuthCredectials(email: email, password: password, fullName: name, userName: userName, profileImage: userImage)
        
        AuthService.shared.registerUser(credentials: creds) { (error, ref) in
            if let error = error {
                print("Error Registering User with \(error.localizedDescription)")
            } else {
                print("Registration complete")
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                guard let rootVCRef = window.rootViewController as? MainTabBarController else { return }
                rootVCRef.authenticateUserAndConfigureUI()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func profilePicTapped() {
        present(imagePicker, animated: true)
    }
    
    //MARK: Helper
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        imagePicker.delegate = self
        
        view.addSubview(uploadImageBtn)
        uploadImageBtn.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        uploadImageBtn.setDimensions(width: 128.0, height: 128.0)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, nameContainerView, usernameContainerView, signUpBtn])
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: uploadImageBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(logInBtn)
        logInBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 8.0)
        logInBtn.centerX(inView: view)
        
    }
    
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileImage = image
        dismiss(animated: true, completion: nil)
        uploadImageBtn.clipsToBounds = true
        uploadImageBtn.layer.cornerRadius = 128/2
        uploadImageBtn.layer.borderWidth = 3
        uploadImageBtn.layer.borderColor = UIColor.white.cgColor
        uploadImageBtn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        uploadImageBtn.imageView?.contentMode = .scaleAspectFit
        uploadImageBtn.layer.masksToBounds = true
    }
    
}

