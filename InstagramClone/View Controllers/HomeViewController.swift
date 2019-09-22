//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutbuttonPressed(_ sender: Any) {
       
        do {
            try  Auth.auth().signOut()
 
        }
        catch let logoutError{
            print(logoutError)
        }
     let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signinVc =  storyboard.instantiateViewController(withIdentifier: "SignInViewController")
    
        self.present(signinVc,animated: true,completion: nil)

    }
    
}
