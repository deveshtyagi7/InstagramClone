//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var user :Users!
    var posts : [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        fetchUser()
        fetchMyPosts()
    }
    func fetchMyPosts(){
        guard let currentUser = Api.User.CURRENT_USER else{
            return
        }
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                print(post)
                self.posts.append(post)
                self.photoCollectionView.reloadData()
            })
        })
    }
    
    func fetchUser(){
        Api.User.observeCurrentUser { (user) in
            self.user = user
            self.photoCollectionView.reloadData()
        }
        
    }
    
    
}
extension ProfileViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostsCollectionViewCell", for: indexPath) as! MyPostsCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user{
            headerViewCell.user = user
        }
        
        return headerViewCell
    }
    
}
extension ProfileViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoCollectionView.frame.size.width / 3 - 1, height: photoCollectionView.frame.size.width / 3 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
