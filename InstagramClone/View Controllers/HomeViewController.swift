//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
        

    }
    
    func loadPosts(){
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot : DataSnapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let captionText = dict["Caption"] as! String
                let photoUrlString = dict["postUrl"] as! String
                let post = Post(captionText: captionText, photoURLString: photoUrlString)
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
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

extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! CustomCell
        cell.PostCaption.text = posts[indexPath.row].caption
     //   cell.PostImage.image = UIImage(named: "pic.jpeg")
        
//        if let photoUrl = posts[indexPath.row].photoURL {
          let url = URL(string :posts[indexPath.row].photoURL!)
//        URLSession.shared.dataTask(with: url!) { (data, respose, error) in
//            if error != nil{
//                print(error!)
//                return
//            }
//            cell.PostImage.image = UIImage(data: data!)

//        }
//        }
            
        KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil) { (image, error, cache, urll) in
            cell.PostImage.image = image
        }
            
        
        return cell
       
    }
}
