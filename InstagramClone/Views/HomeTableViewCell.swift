//
//  HomeTableViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 11/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//


import UIKit
import ProgressHUD

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
  
    
    var post: Post?{
        didSet{
            updateView()
        }
    }
    
    var user: Users?{
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
        Api.Post.observePost(withId: post!.id!, completion: {
            post in
            self.updateLike(post: post)
        })
        
        
        Api.Post.observeLikeCount(withPostId: post!.id!) { (value) in
             self.likeCountButton.setTitle("\(value) likes", for: .normal)
        }
        
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
        
        Api.Post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
        }) { (error) in
            ProgressHUD.showError(error)
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
