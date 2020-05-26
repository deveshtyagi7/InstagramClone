//
//  MyPostsApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class MyPostsApi{
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
}
