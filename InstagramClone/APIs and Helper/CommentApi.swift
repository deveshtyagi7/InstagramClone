//
//  CommentApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 19/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class CommentApi{
    var REF_COMMENTS = Database.database().reference().child("Comments")
    
    func observeComment(withPostId id : String ,completion : @escaping (Comment) -> Void ){
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
}
