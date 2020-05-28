//
//  ExploreController.swift
//  MVVM_Twitter
//
//  Created by Ankit Saxena on 12/05/20.
//  Copyright © 2020 Ankit Saxena. All rights reserved.
//

import UIKit

let reuseUserCell = "userCell"

class ExploreController: UITableViewController {
    
    //MARK: Properties
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filterUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isSearchActive: Bool {
        return searchController.isActive || !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: LifeCylcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: Selectors
    
    //MARK: Helper

    fileprivate func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseUserCell)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        fetchUsers()
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search a User"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchResultsUpdater = self
    }

    //MARK: API
    
    private func fetchUsers() {
        UserService.shared.fetchUsers { [weak self] (users) in
            self?.users = users
        }
    }
    
}

//MARK: Table View Delegate

extension ExploreController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseUserCell, for: indexPath) as! UserCell
        let user = isSearchActive ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchActive ? filterUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


//MARK: Search Delegate

extension ExploreController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("typed \(searchController.searchBar.text)")
        guard let searchText = searchController.searchBar.text else { return }
        filterUsers = users.filter { $0.username.contains(searchText)  }
    }

}
