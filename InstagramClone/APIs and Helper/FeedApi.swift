//
//  FeedApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 17/07/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi{
    //First we will create a base reference.
    var REF_FEED = Database.database().reference().child("feed")
    
    //Method related to the api
    
    func observeFeed(withId id : String, completion : @escaping (Post) -> Void){
        
        //Accessing the post id from feed document
        REF_FEED.child(id).observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            // Extracting the post from the fetched key
            Api.Post.observePost(withId: key, completion: {
                (post) in
                completion(post)
            })
        }
    }
    
    func observeFeedRemoved(withId id : String, completion : @escaping (String) -> Void){
        
        REF_FEED.child(id).observe(.childRemoved) { (snapshot) in
            let key = snapshot.key
            completion(key)
        }
    }
}


