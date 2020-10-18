//
//  EditProfileController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 18/10/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {
        
    //MARK: Properties
    private lazy var headerView: EditProfileHeader = {
        let view = EditProfileHeader(user: user)
        
        return view
    }()
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var userInfoChanged = false
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    private var user: User
    private let screenWidth = UIScreen.main.bounds.width
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    
    private let imagePicker = UIImagePickerController()
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigatonBar()
        configureTableView()
        configureUI()
    }
    
    //MARK: API
    private func updateUserData() {
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if userInfoChanged && !imageChanged {
            UserService.shared.saveUserData(user: user) { (err, ref) in
                print("User Info Updated!")
                self.delegate?.controller(self, wantsToUpdate: self.user)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        if userInfoChanged && imageChanged {
            UserService.shared.saveUserData(user: user) { (err, ref) in
                self.updateProfileImage()
            }
        }
    }
    
    private func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { (profileImageUrl) in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    
    private func configureUI() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func configureNavigatonBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done
                                                            , target: self, action: #selector(handleDone))
//        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView() {
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EDIT_PROFILE_CELL)
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 180.0)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
    }
    
    //MARK: Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        guard imageChanged || userInfoChanged else { return }
        updateUserData()
    }
    
}

//MARK: Table View Delegate
extension EditProfileController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EDIT_PROFILE_CELL, for: indexPath) as! EditProfileCell
        cell.delegate = self
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

//MARK: Edit Profile HEader Delegate

extension EditProfileController: EditProfileHeaderDelegate {
    
    func didTapChangeProfilePhoto() {
        print("Handle Profile Header")
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: Image Picker Delegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: Edit Profile Delegate
extension EditProfileController: EditProfileCellDelegate {
    
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewmodel = cell.viewModel else { return }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        switch viewmodel.option {
        case .fullName:
            guard let fullName = cell.infoTextField.text else { return }
            user.fullname = fullName
        case .userName:
            guard let userName = cell.infoTextField.text else { return }
            user.username = userName
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
    
}

//MARK: Constants
let EDIT_PROFILE_CELL = "EditProfileCell"
