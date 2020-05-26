//
//  User.swift
//  PicSick
//
//  Created by Devesh Tyagi on 11/04/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
class Users{
    
    var email : String?
    var profileImageUrl : String?
    var userName : String?
    
}

extension Users{
    
    static func transformUser(dict : [String : Any]) -> Users{
       
        let user = Users()
        user.email = dict["Email"] as? String
        user.profileImageUrl = dict["ProfilePictureUrl"] as? String
        user.userName = dict["Username"] as? String
        return user
        
        
    }
}

