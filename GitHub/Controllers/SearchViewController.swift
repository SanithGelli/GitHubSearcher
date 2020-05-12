//
//  ViewController.swift
//  GitHub
//
//  Created by Sanith on 5/5/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var resultVc = ResultsViewController()
    
    var users: [ItemsResponseModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Github Seacher"
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
            self.tableView.setEmptyMessage("No Data, Please try sreaching with other name.")
        } else {
            self.tableView.restore()
        }
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserCell", owner: self, options: nil)?.first as! UserCell
        cell.userImage?.downloaded(from: users[indexPath.row].avatar_url ?? "github-logo.png")
        cell.name?.text = users[indexPath.row].login ?? ""
        cell.repos?.text = "Repo: #\(users[indexPath.row].id ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.searchBar.resignFirstResponder()
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "resultsVc") as! ResultsViewController
    
        vc.selectedUser = users[indexPath.row].login!
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchSearchUsers(searchString: String, onCompletion : @escaping (_ UpdatesModel: UsersResponseModel?, _ error: Error?) -> Void) {
        
        var url: URL?
        let urlString : String = "https://api.github.com/search/users?q=\(searchString)"
        
        url = URL(string: urlString)
        
        NetworkManager.sharedManager.getRequest(url: url) { (data, error) in
            if let dataInstance = data {
                do {
                    
                    let responseModel = try JSONDecoder().decode(UsersResponseModel.self, from: dataInstance)
                    self.users = responseModel.items ?? []
                    
                }catch {
                    print(error)
                }
            }
        } 
    }
}

extension SearchViewController  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        
        if !searchText.isEmpty {
            self.fetchSearchUsers(searchString: searchText) { (model, error) in
                if let model = model {
                    self.users = model.items ?? []
                }
            }
        }
        
        if(searchText == "")
        {
            self.users.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
