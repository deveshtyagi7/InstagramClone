//
//  Post_CommentApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 19/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import Foundation
import FirebaseDatabase
class Post_CommentApi{
    var REF_POST_COMMENTS = Database.database().reference().child("post-comments")
    
    func observePostComment(withPostID id : String , completion : @escaping (String)-> Void){
        REF_POST_COMMENTS.child(id).observe(.childAdded, with: {
            snapshot in
            let snapshotKey = snapshot.key
            completion(snapshotKey)
        })
    }


}
