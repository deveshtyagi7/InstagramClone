//
//  Post.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 25/11/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import Foundation
class Post {
    var caption : String?
    var photoURL : String?
    var uid : String?
    
 
}

extension Post{
    static func transformPost(dict: [String :Any]) ->Post{
    
    let post = Post()
    post.caption = dict["Caption"] as? String
    post.photoURL = dict["postUrl"] as? String
        post.uid = dict["uid"] as? String
    return post 
    }
    
    static func transformPost(){
        
    }
    
    
    
}
