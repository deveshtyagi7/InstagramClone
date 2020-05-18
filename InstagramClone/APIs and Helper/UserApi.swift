//
//  UserApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 19/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class UserApi{
    var REF_USERS = Database.database().reference().child("Users")
    
    func observeUsers(withId uid : String , completion : @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                     let user = User.transformUser(dict: dict)
                         completion(user)
                     }
                
        })
    }

}
