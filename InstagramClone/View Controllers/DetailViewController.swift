//
//  DetailViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 09/10/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var postId = ""
    var post = Post()
    var user = Users()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       loadpost()
     
    }
    
    func loadpost(){
        
        Api.Post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {return}
            self.fetchUser(uid: postUid , completed: {
                
                
                self.post = post
               
                self.tableView.reloadData()
                
            })
        }
    }
    func fetchUser(uid :String , completed : @escaping () -> Void) {
        
        Api.User.observeUsers(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToComment"{
            let commentViewController = segue.destination as! CommentViewController
            let postId = sender as! String
            commentViewController.postId = postId
        }
        if segue.identifier == "DetailToUserProfile"{
            let profileViewController = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileViewController.userId = userId
        }
    }

}
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        // cell.updateView(post: post)
        
        return cell
    }
    
    
}
extension DetailViewController : HomeTableViewCellDelegate{
    func goToProfileUserVC(userID: String) {
        performSegue(withIdentifier: "DetailToUserProfile", sender: userID)
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "DetailToComment", sender: postId)
    }
    
}
