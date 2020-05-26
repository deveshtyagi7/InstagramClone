//
//  CommentViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 16/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit
import ProgressHUD
import SDWebImage

class CommentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postId : String!
    var comments = [Comment]()
    var users = [Users]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        //sendButton.isEnabled = false
        tableView.dataSource = self
        tableView.estimatedRowHeight = 69
        tableView.rowHeight = UITableView.automaticDimension
        empty()
        CheckTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func keyboardWillShow(_ notification : NSNotification){
        
        
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3){
            
            self.constraintToBottom.constant =  keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc func keyboardWillHide(_ notification : NSNotification){
        UIView.animate(withDuration: 0.3){
            
            self.constraintToBottom.constant = 0.0
            self.view.layoutIfNeeded()
        }
        
    }
    func loadComments(){
        Api.Post_Comment.observePostComment(withPostID: self.postId, completion: {
            (snapshotkey) in
            
            Api.Comment.observeComment(withPostId: snapshotkey, completion: {
                comment in
                
                self.fetchUser(uid: comment.uid! , completed: {
                    
                        self.comments.append(comment)
                        self.tableView.reloadData()
                    
                })
            })
            
            
        })
            
    }
    func fetchUser(uid :String , completed : @escaping () -> Void) {
        Api.User.observeUsers(withId: uid, completion: {
                   user in
                   self.users.append(user)
                   completed()
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
        let commentsReference = Api.Comment.REF_COMMENTS
        //reference of post Id
        let newCommentId = commentsReference.childByAutoId().key
        //reference of new post
        let newCommentsReference = commentsReference.child(newCommentId!)
        
        guard let currentUser = Api.User.CURRENT_USER else{
            return
        }
        let currentUserID = currentUser.uid
        newCommentsReference.setValue(["uid": currentUserID ,"CommentText":commentTextField.text! ], withCompletionBlock: { (error, ref) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            
            let postCommentRef =
                Api.Post_Comment.REF_POST_COMMENTS.child(self.postId).child(newCommentId!)
            postCommentRef.setValue(true) { (error, ref) in
                if error != nil{
                    // show some animation
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            }
            
            self.empty()
            self.view.endEditing(true)
            
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
