//
//  People TableViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 12/07/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user : Users?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        nameLabel.text = user?.userName
        if let photoUrlString = user?.profileImageUrl{
            let photoURL = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoURL , placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
