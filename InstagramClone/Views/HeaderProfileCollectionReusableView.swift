//
//  HeaderProfileCollectionReusableView.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit
protocol HeaderProfileCollectionReusableViewViewDelegate {
    func updateFollowButton(forUser user : Users)
}

protocol HeaderProfileCollectionReusableViewViewDelegateSwitchSettingVC {
    func goToSettingVC()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    var delegate : HeaderProfileCollectionReusableViewViewDelegate?
    var delegate2 : HeaderProfileCollectionReusableViewViewDelegateSwitchSettingVC?
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
        
        Api.MyPosts.fetchCountMyPosts(userId: user!.id!) { (postCount) in
            self.postCountLabel.text = "\(postCount)"
        }
        
        Api.Follow.fetchCountFollowing(userId: user!.id!) { (followingCount) in
            self.followingCountLabel.text = "\(followingCount)"
        }
        Api.Follow.fetchCountFollowers(userId: user!.id!) { (followerCount) in
            self.followingCountLabel.text = "\(followerCount)"
        }
        
        if user?.id == Api.User.CURRENT_USER?.uid {
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.addTarget(self, action: #selector(goToSettingVc), for: .touchUpInside)
        } else {
            updateStateFollowButton()
            
        }
        
    }
    @objc func goToSettingVc(){
        delegate2?.goToSettingVC()
    }
    
    func updateStateFollowButton(){
        if user!.isFollowing!{
            configureUnFollowButton()
        }else{
            configureFollowButton()
        }
    }
    
    
    func configureFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = UIColor(displayP3Red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        self.followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
    }
    func configureUnFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        self.followButton.setTitle("Following", for: .normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    @objc func  followAction(){
        if user!.isFollowing! == false{
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser :user!)
        }
    }
    @objc func  unFollowAction(){
        if user!.isFollowing! == true{
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
            delegate?.updateFollowButton(forUser :user!)
        }
        
        
    }
}
