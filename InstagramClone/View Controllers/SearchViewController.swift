//
//  SearchViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 29/08/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var users: [Users] = []
    var searchBar = UISearchBar()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
    }
    
    func doSearch(){
        if let searchText = searchBar.text?.lowercased(){
            self.users.removeAll()
            self.tableView.reloadData()
            Api.User.queryUsers(withText: searchText) { (user) in
                self.isFollowing(userId: user.id!,completed: {
                    (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            }
            
        }
    }
    func isFollowing(userId : String , completed : @escaping(Bool)-> Void ){
        Api.Follow.isFollowing(userID: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "searchToProfile"{
            let profileViewController = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileViewController.userId = userId
            profileViewController.delegate = self
        }
    }
    
    
}
extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
        
    }
    
}
extension SearchViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return users.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        
        return cell
        
    }
}

extension SearchViewController : PeopleTableViewCellDelegate{
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "searchToProfile", sender: userId)
    }
}

extension SearchViewController : HeaderProfileCollectionReusableViewViewDelegate {
    
    func updateFollowButton(forUser user: Users) {
        for u in self.users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}
