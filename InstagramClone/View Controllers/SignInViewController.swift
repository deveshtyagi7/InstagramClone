//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeTextField(textFieldName: EmailTextField, placeholderString: "Email")
        ChangeTextField(textFieldName: PasswordTextField, placeholderString: "Password")
    }
    

    @IBOutlet weak var EmailTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    func ChangeTextField(textFieldName : UITextField!  , placeholderString : String ) -> Void {
        textFieldName.attributedPlaceholder = NSAttributedString(string: placeholderString , attributes: [NSAttributedString.Key.foregroundColor :UIColor.gray])
        textFieldName.backgroundColor = UIColor.black
        textFieldName.textColor = .white
    }

}
