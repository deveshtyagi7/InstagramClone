//
//  Post.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 25/11/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import Foundation
class Post {
    var caption : String
    var photoURL : String?
    
    init( captionText : String, photoURLString : String) {
        caption = captionText
        photoURL = photoURLString
    }
}
