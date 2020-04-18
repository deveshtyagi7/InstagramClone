//
//  CommentViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 16/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

import FirebaseDatabase
import SDWebImage

class CommentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let postId = "-M4i4BvO7j74kQ2EJVBR"
    var comments = [Comment]()
     var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sendButton.isEnabled = false
        tableView.dataSource = self
       tableView.estimatedRowHeight = 69
       tableView.rowHeight = UITableView.automaticDimension
        empty()
        CheckTextField()
        loadComments()
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.tabBarController?.tabBar.isHidden = true
       }
       
    func loadComments(){
         let postCommentRef = Database.database().reference().child("post-comments").child(self.postId)
        postCommentRef.observe(.childAdded) { (snapshot) in
       
            Database.database().reference().child("Comments").child(snapshot.key).observeSingleEvent(of: .value) { (snapshotComment) in
                if let dict = snapshotComment.value as? [String : Any]{
                    let newComment = Comment.transformComment(dict: dict)
                    
                    
                    self.fetchUser(uid: newComment.uid!) {
                    self.comments.append(newComment)
                    self.tableView.reloadData()
                    }
                   
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
    
    
   func CheckTextField(){
       commentTextField.addTarget(self, action: #selector(UpdateTextFeild), for: UIControl.Event.editingChanged)
       
   }
    @objc func UpdateTextFeild(){
        
        if let commentText = commentTextField.text, !commentText.isEmpty{
            sendButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            sendButton.isEnabled = true
            return
            
        }
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sendButton.isEnabled = false
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let commentsReference = Database.database().reference().child("Comments")
        //reference of post Id
        let newCommentId = commentsReference.childByAutoId().key
        //reference of new post
        let newCommentsReference = commentsReference.child(newCommentId!)
         
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        let currentUserID = currentUser.uid
        newCommentsReference.setValue(["uid": currentUserID ,"CommentText":commentTextField.text! ], withCompletionBlock: { (error, ref) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
           
            let postCommentRef = Database.database().reference().child("post-comments").child(self.postId).child(newCommentId!)
            postCommentRef.setValue(true) { (error, ref) in
                if error != nil{
                    // show some animation
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            }
            
            self.empty()
            })
    }
    func empty(){
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
    }
    
}

extension CommentViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
       // cell.updateView(post: post)
    
        return cell
       
    }
}
