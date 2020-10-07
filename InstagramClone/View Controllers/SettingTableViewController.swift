//
//  SettingTableViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/09/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit
import ProgressHUD

protocol SettingTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var delegate : SettingTableViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        usernameTextField.delegate = self
        navigationItem.title = "Edit Profile"
        fetchCurrentUser()
    }
    
    func fetchCurrentUser(){
        Api.User.observeCurrentUser { (user) in
            self.usernameTextField.text = user.userName
            self.emailTextField.text = user.email
            if let profileURL = URL(string: user.profileImageUrl!){
                self.profileImageView.sd_setImage(with: profileURL)
            }
        }
    }
    @IBAction func changeProfileImageBtnPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate =  self
        present(pickerController, animated: true, completion: nil )
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        ProgressHUD.show("Updating")
        if let profileImage = self.profileImageView.image , let imageData = profileImage.jpegData(compressionQuality: 0.1){
            AuthServices.updateUserInfo(username: usernameTextField.text!, email: emailTextField.text!, imageData: imageData) {
                ProgressHUD.showSuccess("Sucess")
                self.delegate?.updateUserInfo()
            } onError: { (error) in
                ProgressHUD.showError(error)
            }
        
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        AuthServices.logout(completion: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signinVc =  storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            
            self.present(signinVc,animated: true,completion: nil)
        }) { (error) in
            ProgressHUD.showError(error)
            
        }
    }
}
extension SettingTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
extension SettingTableViewController :  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
