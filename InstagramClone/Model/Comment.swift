//
//  Comment.swift
//  PicSick
//
//  Created by Devesh Tyagi on 17/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
class Comment {
    var commentText : String?
    var uid : String?
    
 
}

extension Comment{
    static func transformComment(dict: [String :Any]) ->Comment{
    
    let comment = Comment()
    comment.commentText = dict["CommentText"] as? String
    comment.uid = dict["uid"] as? String
    return comment
    }
    
}
