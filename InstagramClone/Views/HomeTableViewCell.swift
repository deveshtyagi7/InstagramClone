//
//  HomeTableViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 11/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var homeVC : HomeViewController?
    var postRef : DatabaseReference!
    
    var post: Post?{
        didSet{
            updateView()
        }
    }
    
    var user: User?{
        didSet{
            setupUserInfo()
        }
    }
    
    
    
    func updateView(){
        captionLabel.text = post?.caption
        
        if let photoUrlString = post?.photoURL{
            let photoURL = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoURL)
        }
        Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let post  = Post.transformPost(dict: dict, key: snapshot.key)
                self.updateLike(post: post)
            }
            
        })
        Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int{
                self.likeCountButton.setTitle("\(value) likes", for: .normal)
            }
        })
        
    }
    func updateLike(post : Post){
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {return}
        if count != 0{
            likeCountButton.setTitle("\(count) likes", for: .normal)
        }else{
            likeCountButton.setTitle("Be the first to like this", for: .normal)
        }
        
    }
    
    
    func setupUserInfo() {
        nameLabel.text = user?.userName
        if let photoUrlString = user?.profileImageUrl{
            let photoURL = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoURL , placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.text = ""
        captionLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectCommentImageView))
        commentImageView.isUserInteractionEnabled = true
        commentImageView.addGestureRecognizer(tapGesture)
        
        let tapGestureFOrLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewPressed))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(tapGestureFOrLikeImageView)
        
    }
    
    @objc func handleSelectCommentImageView(){
        if let id = post?.id{
            
            homeVC?.performSegue(withIdentifier: "goToComment", sender: id)
        }
        
    }
    @objc func likeImageViewPressed(){
        postRef = Api.Post.REF_POSTS.child(post!.id!)
        incrementLikes(forRef : postRef)
        
    }
    
    func incrementLikes(forRef ref: DatabaseReference){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String : Any]{
                let post  = Post.transformPost(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
