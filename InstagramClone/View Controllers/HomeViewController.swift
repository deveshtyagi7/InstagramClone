//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import SDWebImage
import ProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var acitivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var users = [Users]()
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
        
        
    }
    
    func loadPosts(){
        acitivityIndicatorView.startAnimating()
        Api.Post.observePosts { (post) in
            guard let postUid = post.uid else {return}
            self.fetchUser(uid: postUid , completed: {
                
                
                self.posts.append(post)
                self.acitivityIndicatorView.stopAnimating()
                self.tableView.reloadData()
                
            })
            
            
        }
    }
    
    func fetchUser(uid :String , completed : @escaping () -> Void) {
        
        Api.User.observeUsers(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    @IBAction func logOutbuttonPressed(_ sender: Any) {
    AuthServices.logout(completion: {
             let storyboard = UIStoryboard(name: "Start", bundle: nil)
                   let signinVc =  storyboard.instantiateViewController(withIdentifier: "SignInViewController")
                   
                   self.present(signinVc,animated: true,completion: nil)
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToComment"{
            let commentViewController = segue.destination as! CommentViewController
            let postId = sender as! String
            commentViewController.postId = postId
        }
    }
    
}

extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return posts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeVC = self
        // cell.updateView(post: post)
        
        return cell
        
    }
}
