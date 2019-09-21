//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth
import KRProgressHUD

class SignInViewController: UIViewController {

    
    @IBOutlet weak var EmailIdTextField: UITextField!
    
    @IBOutlet weak var PasswordText: UITextField!
    
    
    @IBOutlet weak var SignInButton: UIButton!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeTextField(textFieldName: EmailIdTextField, placeholderString: "Email")
        ChangeTextField(textFieldName: PasswordText, placeholderString: "Password")
        CheckTextFields()
        KRProgressHUD.set(activityIndicatorViewColors: [.black,.lightGray])
     
        
    }
   // Auto login
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            
            self.performSegue(withIdentifier: "GoToHome", sender: nil)
        }
    }
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        view.endEditing(true)
        KRProgressHUD.show(withMessage:"Signing In" )
        AuthServices.SignIn(email: EmailIdTextField.text!, password: PasswordText.text!, completion: {
            self.performSegue(withIdentifier: "GoToHome", sender: nil)
            KRProgressHUD.dismiss()
        }, OnError: {error in print(error!)
            KRProgressHUD.showWarning(withMessage: "Invalid Email Id or Password")
            })
   
    }
     // to dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    
    func ChangeTextField(textFieldName : UITextField!  , placeholderString : String ) -> Void {
        textFieldName.attributedPlaceholder = NSAttributedString(string: placeholderString , attributes: [NSAttributedString.Key.foregroundColor :UIColor.gray])
        textFieldName.backgroundColor = UIColor.black
        textFieldName.textColor = .white
    }
    
    func CheckTextFields(){
        EmailIdTextField.addTarget(self, action: #selector(UpdateButton), for: UIControl.Event.editingChanged)
        PasswordText.addTarget(self, action: #selector(UpdateButton), for: UIControl.Event.editingChanged)
    }
    
    @objc func UpdateButton(){
        guard let emailId = EmailIdTextField.text, !emailId.isEmpty, let password = PasswordText.text, !password.isEmpty else{
            SignInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            SignInButton.isEnabled =  false
            return
        }
        SignInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        SignInButton.isEnabled = true
    }
}
