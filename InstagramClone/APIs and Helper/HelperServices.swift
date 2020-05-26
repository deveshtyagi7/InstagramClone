//
//  HelperServices.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import ProgressHUD
import FirebaseStorage
class HelperServices{
    static func uploadDataToServer(data: Data , caption : String, onSucess: @escaping () -> Void){
        let photoId = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF ).child("Posts").child(photoId)
        storageRef.putData(data, metadata: nil) { (metaData, error) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                let photoUrl = url?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!, caption: caption, onSucess: onSucess)
                
            })
            
        }
    }
    static func sendDataToDatabase(photoUrl: String, caption : String, onSucess : @escaping () -> Void){
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        guard let currentUser = Api.User.CURRENT_USER?.uid else {return}
        newPostReference.setValue(["uid": currentUser ,"postUrl":photoUrl,"Caption":caption ]) { (error, ref) in
            if error != nil{
                ProgressHUD.showError( error?.localizedDescription)
                return
            }
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUser).child(newPostId!)
            myPostRef.setValue(true) { (error, ref) in
                if error != nil{
                    // show some animation
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            }
            
            
            ProgressHUD.showSuccess("Posted")
            print("Posted")
            onSucess()
            
        }
    }
    
}
