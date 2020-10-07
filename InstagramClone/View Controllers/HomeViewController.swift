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
        
        Api.Feed.observeFeed(withId: Api.User.CURRENT_USER!.uid) { (post) in
            guard let postUid = post.uid else {return}
            self.fetchUser(uid: postUid , completed: {
                
                
                self.posts.append(post)
                self.acitivityIndicatorView.stopAnimating()
                self.tableView.reloadData()
                
            })
        }
        Api.Feed.observeFeedRemoved(withId: Api.User.CURRENT_USER!.uid) { (post) in
            //this will check all the elements in  array if its same as key then it will remove it from array
            self.posts = self.posts.filter{$0.id != post.id}
            self.users = self.users.filter{$0.id != post.uid }
//            for(index, post) in self.posts.enumerated(){
//                if post.id  == key{
//                    self.posts.remove(at: index)
//                }
//           }
            self.tableView.reloadData()
        }
        
        
        //        Api.Post.observePosts { (post) in
        //            guard let postUid = post.uid else {return}
        //            self.fetchUser(uid: postUid , completed: {
        //
        //
        //                self.posts.append(post)
        //                self.acitivityIndicatorView.stopAnimating()
        //                self.tableView.reloadData()
        //
        //            })
        //
        //
        //        }
    }
    
    func fetchUser(uid :String , completed : @escaping () -> Void) {
        
        Api.User.observeUsers(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToComment"{
            let commentViewController = segue.destination as! CommentViewController
            let postId = sender as! String
            commentViewController.postId = postId
        }
        if segue.identifier == "homeToProfile"{
            let profileViewController = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileViewController.userId = userId
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
        cell.delegate = self
        // cell.updateView(post: post)
        
        return cell
        
    }
}

extension HomeViewController : HomeTableViewCellDelegate{
    func goToProfileUserVC(userID: String) {
        performSegue(withIdentifier: "homeToProfile", sender: userID)
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "goToComment", sender: postId)
    }
    
}
