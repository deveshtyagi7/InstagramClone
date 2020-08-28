//
//  AuthServices.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 18/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class AuthServices {
    
    
    static func SignIn(email : String, password : String , completion : @escaping () -> Void , OnError : @escaping (_ errorMsg : String?) ->Void ){
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if error != nil{
                OnError(error?.localizedDescription)
                // print(error?.localizedDescription)
                return
            }
            completion()
        }
    }
    
    static func SignUP(username : String
        ,email : String, password : String ,imageData : Data, completion : @escaping () -> Void , OnError : @escaping (_ errorMsg : String?) ->Void ){
        // creating a user on firebase
        Auth.auth().createUser(withEmail: email, password: password ) { (user, error) in
            if error != nil{
               OnError(error?.localizedDescription)
                return
            }
            else{
                print("registeration is successful")
                let Uid = Auth.auth().currentUser?.uid
                // creating table reference
                let newRef = Database.database().reference().child("Users").child(Uid!)
                // creating  storage reference
                let StorageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF ).child("ProfilePicture").child(Uid!)
                
                //Selecting & converting picture to firebase extention
                
                    
                    
                    StorageRef.putData(imageData, metadata: nil , completion: { (metadata, error) in
                        if error != nil{
                            return
                        }
                        StorageRef.downloadURL(completion: { (url, error) in
                            let profileImageUrl = url?.absoluteString
                            newRef.setValue(["Username":username,"username_lowercase" : username.lowercased() ,"Email" : email,"ProfilePictureUrl" : profileImageUrl])
                        })
                        
                    })
                    
                completion()
            }
            
            
        }
       
    }
    static func logout(completion : @escaping () -> Void , OnError : @escaping (_ errorMsg : String?) ->Void){

       do {
           try  Auth.auth().signOut()
           completion()
       }
       catch let logoutError{
        OnError(logoutError.localizedDescription)
       }
       
    }
    
    
}
