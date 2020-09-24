//
//  FollowApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 12/07/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FollowApi{
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id : String){
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        }
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
          REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String){
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
                 if let dict = snapshot.value as? [String: Any]{
                     for key in dict.keys{
                         Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                     }
                 }
             }
       REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    
    func isFollowing(userID : String, completed : @escaping (Bool)-> Void){
        REF_FOLLOWERS.child(userID).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                completed(false)
            }else{
                completed(true)
            }
        }
    }
    
    func fetchCountFollowing(userId : String,completion : @escaping (Int) -> Void){
        REF_FOLLOWING.child(userId).observe(.value) { (snapshot) in
            let count = Int(snapshot.childrenCount)
            
            completion(count)
        }
    }
    
    func fetchCountFollowers(userId : String,completion : @escaping (Int) -> Void){
        REF_FOLLOWERS.child(userId).observe(.value) { (snapshot) in
            let count = Int(snapshot.childrenCount)
            
            completion(count)
        }
    }

}
