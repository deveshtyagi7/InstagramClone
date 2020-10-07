//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import ProgressHUD

class SignUpViewController: UIViewController{
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var EmailIdTextField: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var SignUpButton: UIButton!
    
    var selectedImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeTextField(textFieldName: UserNameTextField, placeholderString: "Username")
        ChangeTextField(textFieldName: EmailIdTextField, placeholderString: "Email")
        ChangeTextField(textFieldName: PasswordText, placeholderString: "Password")
        
        //to capture the tap on image selector
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectProfilePicture))
        imagePicker.addGestureRecognizer(tapGesture)
        imagePicker.isUserInteractionEnabled =  true
        
        CheckTextFields()
        SignUpButton.isEnabled = false
        
        
    }
    
    
    
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func SignUpPressed(_ sender: Any) {
        view.endEditing(true)
        //KRProgressHUD.show(withMessage: "Wait")
        if let profileImage = self.selectedImage , let imageData = profileImage.jpegData(compressionQuality: 0.1){
            
            AuthServices.SignUP(username: UserNameTextField.text!, email: EmailIdTextField.text!, password: PasswordText.text!, imageData: imageData, completion: {
                self.performSegue(withIdentifier: "GoToHomeBySiginUp", sender: nil)
            }, OnError: { (errormsg) in
                    print(errormsg!)
                
            })
           
       
        
        }
        else{
            print("No profile picture is selected")
        }
    }
    
    
    //to change the look of text field
    func ChangeTextField(textFieldName : UITextField!  , placeholderString : String ) -> Void {
        textFieldName.attributedPlaceholder = NSAttributedString(string: placeholderString , attributes: [NSAttributedString.Key.foregroundColor :UIColor.gray])
        textFieldName.backgroundColor = UIColor.black
        textFieldName.textColor = .white
    }
    
    
    
}









extension SignUpViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = Image
            imagePicker.image = Image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func SelectProfilePicture(){
        let pickerController = UIImagePickerController()
        pickerController.delegate =  self
        present(pickerController, animated: true, completion: nil )
    }
    
    func CheckTextFields(){
        UserNameTextField.addTarget(self, action: #selector(UpdateTextFeild), for: UIControl.Event.editingChanged)
        EmailIdTextField.addTarget(self, action: #selector(UpdateTextFeild), for: UIControl.Event.editingChanged)
        PasswordText.addTarget(self, action: #selector(UpdateTextFeild), for: UIControl.Event.editingChanged)
        
    }
    
    //to disable signUp button
    @objc func UpdateTextFeild(){
        guard let username = UserNameTextField.text, !username.isEmpty ,let emailId = EmailIdTextField.text, !emailId.isEmpty, let password = PasswordText.text, !password.isEmpty else{
            SignUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            SignUpButton.isEnabled =  false
            return
        }
        SignUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        SignUpButton.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
