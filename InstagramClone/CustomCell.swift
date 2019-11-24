//
//  CustomCell.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 25/11/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var PostImage: UIImageView!
    
    @IBOutlet weak var PostCaption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
