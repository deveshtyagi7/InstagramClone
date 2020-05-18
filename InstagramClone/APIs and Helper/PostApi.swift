//
//  PostApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 19/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostApi{
    var REF_POSTS = Database.database().reference().child("Posts")
    
    func observePosts(completion : @escaping (Post) -> Void){
        REF_POSTS.observe(.childAdded) { (snapshot : DataSnapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let newPost = Post.transformPost(dict: dict , key: snapshot.key)
                completion(newPost)
            }
        }
    }
}
