//
//  CommentTableViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 16/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate {
    func goToProfileUserVC(userID : String)
}
class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate : CommentTableViewCellDelegate?
    
    var comment: Comment?{
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
       
        commentLabel.text = comment?.commentText
    }
    
    func setupUserInfo(){
        
    nameLabel.text = user?.userName
            if let photoUrlString = user?.profileImageUrl{
                let photoURL = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoURL , placeholderImage: UIImage(named: "placeholderImg"))
                }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        

    }
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id{
            print("pressed")
            delegate?.goToProfileUserVC(userID: id)
            
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
