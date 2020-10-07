//
//  SettingTableViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 26/09/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBOutlet weak var logoutBtnPressed: UIView!
    
    @IBOutlet weak var saveButtonPressed: UIView!
}
