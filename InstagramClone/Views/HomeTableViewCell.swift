//
//  HomeTableViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 11/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import FirebaseDatabase
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
        setupUserInfo()
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
