//
//  ActionSheetLauncher.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 24/07/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

private let reuseIdentifier = "actionSheetCell"

class ActionSheetLauncher: NSObject {
    
    
    //MARK: Properties
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    
    private lazy var viewModel = ActionSheetViewModel(user: user)
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var cancelButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50/2
        return view
    }()
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    //MARK: Selectors
    
    @objc func handleDismiss() {
        print("Dismiss Tapped!")
        UIView.animate(withDuration: 0.5) {
            self.blackView .alpha = 0
            self.tableView.frame.origin.y = self.tableView.frame.origin.y + 300
        }
    }
    
    //MARK: Helper
    
    func show() {
        print("Action Sheet in show!")
        let height: CGFloat = (60.0 * CGFloat(viewModel.options.count)) + 100
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window = window
        
        self.window?.addSubview(blackView)
        blackView.frame = window.frame
        
        self.window?.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView .alpha = 1
            self.tableView.frame.origin.y = self.tableView.frame.origin.y - height
        }
    }
    
    private func configureTableView() {
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5.0
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
}

//MARK: Table View Delegate Datasource
extension ActionSheetLauncher: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
}
