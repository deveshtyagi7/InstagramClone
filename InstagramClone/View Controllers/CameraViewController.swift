//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import KRProgressHUD

class CameraViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var RemoveButton: UIBarButtonItem!
    @IBOutlet weak var UploadPicture: UIImageView!
    @IBOutlet weak var CaptionTextField: UITextView!
    @IBOutlet weak var ShareButton: UIButton!
    var SelectedImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectPicture))
              UploadPicture.addGestureRecognizer(tapGesture)
              UploadPicture.isUserInteractionEnabled =  true
        
    
        
        
    }
    //to update the share button status
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disableButton()
    }
    
    func disableButton(){
        if SelectedImage != nil{
            self.ShareButton.isEnabled = true
            self.RemoveButton.isEnabled = true
            self.ShareButton.backgroundColor = .black
         //   self.CaptionTextField.text = "Write caption here"
        }
        else{
              self.ShareButton.isEnabled = false
            self.RemoveButton.isEnabled = false
            self.ShareButton.backgroundColor = .darkGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    @IBAction func RemoveButtonPressed(_ sender: Any) {
        clean()
        disableButton()
    }
    @IBAction func ShareButtonPressed(_ sender: Any) {
        view.endEditing(true)
        KRProgressHUD.show(withMessage: "Posting")
        if let profileImage = self.SelectedImage , let imageData = profileImage.jpegData(compressionQuality: 0.1){
            //to create unique id for each post
            let photoId = NSUUID().uuidString
            let StorageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF ).child("Posts").child(photoId)
            StorageRef.putData(imageData, metadata: nil , completion: { (metadata, error) in
                                   if error != nil{
                                     KRProgressHUD.showError(withMessage: error?.localizedDescription)
                                       return
                                   }
                                   StorageRef.downloadURL(completion: { (url, error) in
                                       let postUrl = url?.absoluteString
                                    self.sendDataToDatabase(postUrl: postUrl!)
                                      
                                   })
            })
            
        }
    
        else{
            KRProgressHUD.showError(withMessage: "No Picture Is Seleceted")
            print("No Picture Is Seleceted")
        }
    }
    
    func sendDataToDatabase(postUrl : String){
        //reference of table posts
        let postIdReference = Database.database().reference().child("Posts")
        //reference of post Id
        let newPostId = postIdReference.childByAutoId().key
        //reference of new post
        let newPostReference = postIdReference.child(newPostId!)
        
        guard let currentUser = Auth.auth().currentUser else{
            return 
        }
        let currentUserID = currentUser.uid
        newPostReference.setValue(["uid": currentUserID ,"postUrl":postUrl,"Caption":CaptionTextField.text! ]) { (error, ref) in
            if error != nil{
                KRProgressHUD.showError(withMessage: error?.localizedDescription)
                return
            }
            KRProgressHUD.showSuccess(withMessage: "Posted")
               print("Posted")
            //to clear caption textfield ,reset select picture image, and to chnage view controller to home view
            self.clean()
            self.tabBarController?.selectedIndex = 0
            }
        }
    
    
    @objc func SelectPicture(){
          let pickerController = UIImagePickerController()
          pickerController.delegate =  self
          present(pickerController, animated: true, completion: nil )
      }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            SelectedImage = Image
         UploadPicture.image = Image
       
        }
        
        dismiss(animated: true, completion: nil)
        disableButton()
    }
    func clean(){
        self.CaptionTextField.text = ""
                   self.UploadPicture.image = UIImage(named: "placeholder-photo")
                   self.SelectedImage = nil
    }

}
