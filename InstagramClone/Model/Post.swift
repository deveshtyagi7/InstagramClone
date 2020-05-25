//
//  Post.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 25/11/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post {
    var caption : String?
    var photoURL : String?
    var uid : String?
    var id : String?
    var likeCount : Int?
    var likes : Dictionary<String, Any>?
    var isLiked : Bool?
    
    
}

extension Post{
    static func transformPost(dict: [String :Any], key : String) ->Post{
        
        let post = Post()
        post.id = key
        post.caption = dict["Caption"] as? String
        post.photoURL = dict["postUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUser = Auth.auth().currentUser?.uid{
            
            if post.likes != nil{
                post.isLiked = post.likes![currentUser] != nil
            }
        }
        return post
    }
    
    static func transformPost(){
        
    }
    
    
    
}
