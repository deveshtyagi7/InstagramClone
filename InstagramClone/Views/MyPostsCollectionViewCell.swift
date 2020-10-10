//
//  MyPostsCollectionViewCell.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit
protocol MyPostsCollectionViewCellDelegate {
    func goToDetailVC(postId : String)
}
class MyPostsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    var delegate : MyPostsCollectionViewCellDelegate?
    
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
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tapGestureForPhoto)
    }
    
    @objc func photo_TouchUpInside(){
        if let id = post?.id{
            delegate?.goToDetailVC(postId: id)
        }
    }
    
}

