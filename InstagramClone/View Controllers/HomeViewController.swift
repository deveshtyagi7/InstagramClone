//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var acitivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var users = [User]()
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.tabBarController?.tabBar.isHidden = false
       }
    @IBAction func buttonPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "goToComment", sender: nil)
    }
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
  

    }
    
    func loadPosts(){
        acitivityIndicatorView.startAnimating()
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot : DataSnapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let newPost = Post.transformPost(dict: dict)
                
                
                self.fetchUser(uid: newPost.uid!) {
                    self.posts.append(newPost)
                    self.acitivityIndicatorView.stopAnimating()
                        self.tableView.reloadData()
                }
               
            }
        }
    }
    
    func fetchUser(uid :String , completed : @escaping () -> Void) {
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: DataEventType.value ,with:{
                   snapshot  in
                   if let dict = snapshot.value as? [String: Any]{
                     
                       let user = User.transformUser(dict :dict)
                    self.users.append(user)
                    completed()
                       
                       }
                     
               
           })
        
    }
    
    @IBAction func logOutbuttonPressed(_ sender: Any) {
       
        do {
            try  Auth.auth().signOut()
 
        }
        catch let logoutError{
            print(logoutError)
        }
     let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signinVc =  storyboard.instantiateViewController(withIdentifier: "SignInViewController")
    
        self.present(signinVc,animated: true,completion: nil)

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
       // cell.updateView(post: post)
    
        return cell
       
    }
}
