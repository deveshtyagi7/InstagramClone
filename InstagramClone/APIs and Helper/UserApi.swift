//
//  UserApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 19/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
class UserApi{
    var REF_USERS = Database.database().reference().child("Users")
    
    func observeUsers(withId uid : String , completion : @escaping (Users) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let user = Users.transformUser(dict: dict ,key: snapshot.key)
                         completion(user)
                     }
                
        })
    }
    
    func observeCurrentUser(completion : @escaping (Users) -> Void){
        guard let currentUser = Auth.auth().currentUser else{
                   return 
               }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                     let user = Users.transformUser(dict: dict ,key: snapshot.key)
                   
                         completion(user)
                     }
                
        })
    }
    
    func observeUsers(completion : @escaping (Users) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = Users.transformUser(dict: dict ,key: snapshot.key)
                completion(user)
            }
        }
    }
    
    
    var CURRENT_USER : User?{
        if let currentUser = Auth.auth().currentUser{
            return currentUser
        }
        return nil
    }
    var REF_CURRENT_USER : DatabaseReference?{
        guard let currentUser = Auth.auth().currentUser else{
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }

}
