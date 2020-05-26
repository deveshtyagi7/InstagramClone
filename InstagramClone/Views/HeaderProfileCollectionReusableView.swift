//
//  HeaderProfileCollectionReusableView.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit


class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: Users?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        
        
        self.nameLabel.text = user!.userName
        
        if let photoUrlString = user!.profileImageUrl{
            let photoURL = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoURL)
        }
        
    }
}
