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

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
  

    }
    
    func loadPosts(){
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot : DataSnapshot) in
            if let dict = snapshot.value as? [String : Any]{
                
                let newPost = Post.transformPost(dict: dict)
                self.posts.append(newPost)
                self.tableView.reloadData()
            }
        }
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
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.profileImageView.image = UIImage(named: "photo1.jpeg")
        cell.nameLabel.text = "ABCD"
        cell.postImageView.image = UIImage(named: "photo3.jpeg")
        cell.captionLabel.text = "Abcsegubfjbjkb hscdghmscahgmsv  ,javdhjavhdv hm j,dvakuyvdkahv j,avdlusavxnz, jsc cbhjsdbckw eh ehwvkhjw vkuywgev kcsnsckxj, b,S ack ,bciulsbecywbvlc ,slucglwaebcjblsclsbli  n"
        
        //cell.PostCaption.text = posts[indexPath.row].caption
  
        
        return cell
       
    }
}
