//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeTextField(textFieldName: EmailTextField, placeholderString: "Email")
        ChangeTextField(textFieldName: PasswordTextField, placeholderString: "Password")
        CheckTextFields()
        
    }
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (dataResult, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            print(dataResult?.user.email)
           self.performSegue(withIdentifier: "GoToHome", sender: nil)
        }
        
    }
    
    
    
    
    
    func ChangeTextField(textFieldName : UITextField!  , placeholderString : String ) -> Void {
        textFieldName.attributedPlaceholder = NSAttributedString(string: placeholderString , attributes: [NSAttributedString.Key.foregroundColor :UIColor.gray])
        textFieldName.backgroundColor = UIColor.black
        textFieldName.textColor = .white
    }
    
    func CheckTextFields(){
        EmailTextField.addTarget(self, action: #selector(UpdateTextFeild), for: UIControl.Event.editingChanged)
        PasswordTextField.addTarget(self, action: #selector(UpdateTextFeild), for: UIControl.Event.editingChanged)
    }
    
    @objc func UpdateTextFeild(){
        guard let emailId = EmailTextField.text, !emailId.isEmpty, let password = PasswordTextField.text, !password.isEmpty else{
            SignInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            SignInButton.isEnabled =  false
            return
        }
        SignInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        SignInButton.isEnabled = true
    }
}
