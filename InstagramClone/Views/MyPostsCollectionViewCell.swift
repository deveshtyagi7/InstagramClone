//
//  MyPostsCollectionViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class MyPostsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    
    var post : Post?{
        didSet{
            updateView()
        }
    }
    func updateView(){
        if let photoUrlString = post?.photoURL{
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with : photoUrl)
        }
    }
    
}

