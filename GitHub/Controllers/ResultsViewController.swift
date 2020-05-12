//
//  ResultsViewController.swift
//  GitHub
//
//  Created by Sanith on 5/5/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userJoinedData: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    @IBOutlet weak var userBiography: UILabel!
    @IBOutlet weak var repositorySearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedUser: String = ""
       
    var userModel: SelectedUserResponseModel?
    
    var repos: [UserReposModel] = [UserReposModel]()
    
    var allRepos: [UserReposModel] = [UserReposModel]()
       
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "GitHub Searcher"
        self.repositorySearchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.avatarImage.layer.cornerRadius = 10
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadDataForUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos.count == 0 {
            self.tableView.setEmptyMessage("No Data, Please try sreaching with other name.")
        } else {
            self.tableView.restore()
        }
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("RepositoryCell", owner: self, options: nil)?.first as! RepositoryCell
        cell.repoName?.text = repos[indexPath.row].name!
        cell.forks?.text = "\(repos[indexPath.row].forks!) Forks"
        cell.stars?.text = "\(repos[indexPath.row].stargazers_count!) Stars"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func setUpView(user: SelectedUserResponseModel) {
        self.avatarImage.downloaded(from: user.avatar_url ?? "github-logo.png")
        self.userName.text = user.login
        
        let date = user.created_at?.strstr(needle: "T", beforeNeedle: true)
        
        if let createdDate = date {
           self.userJoinedData.text = "Joined on \(createdDate)"
        }else {
            self.userJoinedData.text = "Date not mentioned"
        }
        
        if let followers = user.followers {
            self.userFollowers.text = "\(followers) followers"
        }else {
            self.userFollowers.text = "followers not mentioned"
        }
        
        if let following = user.following {
            self.userFollowing.text = "following \(following)"
        }else {
           self.userFollowing.text = "following not mentioned"
        }
        
        if let location = user.location {
            self.userLocation.text = location
        }else {
           self.userLocation.text = "followers not mentioned"
        }
        
        if let bio = user.bio {
            self.userBiography.text = bio
        }else {
            self.userBiography.text = "Biography not mentioned"
        }
        
        if let email = user.email {
            self.userEmail.text = email
        }else {
            self.userEmail.text = "Email Id not mentioned"
        }
    }
    
    func getSelectedUser(user: String, onCompletion : @escaping (_ UpdatesModel: SelectedUserResponseModel?, _ error: Error?) -> Void) {
        
        var url: URL?
        let urlString : String = "https://api.github.com/users/\(user)"
        
        url = URL(string: urlString)
        
        NetworkManager.sharedManager.getRequest(url: url) { (data, error) in
            if let dataInstance = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let responseModel = try JSONDecoder().decode(SelectedUserResponseModel.self, from: dataInstance)
                    
                    onCompletion(responseModel, nil)
                    
                }catch {
                    print(error)
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    func getUserRepoList(user: String, onCompletion : @escaping (_ UpdatesModel: [UserReposModel]?, _ error: Error?) -> Void) {
        
        var url: URL?
        let urlString : String = "https://api.github.com/users/\(user)/repos"
        
        url = URL(string: urlString)
        
        NetworkManager.sharedManager.getRequest(url: url) { (data, error) in
            if let dataInstance = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let responseModel = try JSONDecoder().decode([UserReposModel].self, from: dataInstance)
                    onCompletion(responseModel, nil)
                }catch {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    
    private func loadDataForUser() {
        
        dispatchGroup.enter()
        print("task 1 started")
        self.getSelectedUser(user: selectedUser) { (model, error) in
            
            if let model = model {
                //self.userName.text = model.login
                self.userModel = model
            }
            print("task 1 ended")
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        print("task 2 started")
        self.getUserRepoList(user: selectedUser) { (model, error) in
             if let model = model {
                self.repos = model
                self.allRepos = model
            }
            print("task 2 ended")
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("notify called")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if let userModel = self.userModel {
                    self.setUpView(user: userModel)
                }
            }
        }
    }
}

extension ResultsViewController {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            repos = allRepos
        } else {
            let filteredRepos = allRepos.filter { (user) -> Bool in
                return String(user.name!).contains(searchText)
            }
            repos = filteredRepos
        }
        self.tableView.reloadData()
    }
}

extension String {
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        
        return self.substring(from: range.upperBound)
    }
}
