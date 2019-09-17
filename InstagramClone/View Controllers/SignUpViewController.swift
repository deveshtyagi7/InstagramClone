//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController{
    
    
    var SelectedImage : UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeTextField(textFieldName: UserNameTextField, placeholderString: "Username")
        ChangeTextField(textFieldName: EmailIdTextField, placeholderString: "Email")
        ChangeTextField(textFieldName: PasswordText, placeholderString: "Password")
        
        //to capture the tap on image selector
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectProfilePicture))
        imagePicker.addGestureRecognizer(tapGesture)
        imagePicker.isUserInteractionEnabled =  true
        
        
    }
    
  

    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
        // creating a user on firebase
        Auth.auth().createUser(withEmail: EmailIdTextField.text!, password: PasswordText.text!) { (user, error) in
            let DatabaseRef = Database.database().reference().child("Users")
            
            let Uid = Auth.auth().currentUser?.uid
          
            let newRef = DatabaseRef.child(Uid!)
            
            if error != nil{
                print("error while creating user \(error!)")
            }
            else{
                print("registeration is successful")
            }
   
            // creating  storage
            let StorageRef = Storage.storage().reference(forURL: "gs://instagramclone-402eb.appspot.com/").child("ProfilePicture").child(Uid!)
            
            
            //Selecting & converting picture to firebase extention
            if let profileImage = self.SelectedImage , let imageData = profileImage.jpegData(compressionQuality: 0.1){
                
                
                StorageRef.putData(imageData, metadata: nil , completion: { (metadata, error) in
                    if error != nil{
                        return
                    }
                        
                    else{
                        
                        StorageRef.downloadURL(completion: { (url, error) in
                            //creating a database
                           
                            let profileImageUrl = url?.absoluteString
                            
                            newRef.setValue(["Username":self.UserNameTextField.text!,"Email" : self.EmailIdTextField.text!,"ProfilePictureUrl" : profileImageUrl])
                        })
                    
                        
                    }
                    
                })
                
            }
          
           
        }
        
    }
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var EmailIdTextField: UITextField!
    
    @IBOutlet weak var PasswordText: UITextField!
    
    @IBOutlet weak var imagePicker: UIImageView!
    
    //to change the look of text field
    func ChangeTextField(textFieldName : UITextField!  , placeholderString : String ) -> Void {
        textFieldName.attributedPlaceholder = NSAttributedString(string: placeholderString , attributes: [NSAttributedString.Key.foregroundColor :UIColor.gray])
        textFieldName.backgroundColor = UIColor.black
        textFieldName.textColor = .white
    }
    
    
    //
    @objc func SelectProfilePicture(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate =  self
        present(pickerController, animated: true, completion: nil )
    }
    

    
}
extension SignUpViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            SelectedImage = Image
              imagePicker.image = Image
        }
  
        dismiss(animated: true, completion: nil)
            }
    
}
