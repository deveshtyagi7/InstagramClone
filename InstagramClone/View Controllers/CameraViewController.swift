//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Devesh Tyagi on 10/09/19.
//  Copyright © 2019 Devesh Tyagi. All rights reserved.
//

import UIKit
import ProgressHUD
import AVFoundation

class CameraViewController: UIViewController{

    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var uploadPicture: UIImageView!
    @IBOutlet weak var captionTextField: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage : UIImage?
    var videoUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPicture))
        uploadPicture.addGestureRecognizer(tapGesture)
        uploadPicture.isUserInteractionEnabled =  true
        
        
        
        
    }
    //to update the share button status
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disableButton()
    }
    
    func disableButton(){
        if selectedImage != nil{
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = .black
            //   self.CaptionTextField.text = "Write caption here"
        }
        else{
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = .darkGray
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
        ProgressHUD.show("Posting")
        if let profileImage = self.selectedImage ,
            let imageData = profileImage.jpegData(compressionQuality: 0.1){
            HelperServices.uploadDataToServer(data: imageData, caption: captionTextField.text!, onSucess: {
                self.clean()
                self.tabBarController?.selectedIndex = 0
            })
            
        }else{
            ProgressHUD.showError( "No Picture Is Seleceted")
            print("No Picture Is Seleceted")
        }
        
    }
    
    
    
    
    @objc func selectPicture(){
        let pickerController = UIImagePickerController()
        pickerController.delegate =  self
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present(pickerController, animated: true, completion: nil )
    }
    
    func clean(){
        self.captionTextField.text = ""
        self.uploadPicture.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
    }
    
}
extension CameraViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            if let thumbnail = self.thumbnailImageForFileUrl(videoUrl){
                selectedImage = thumbnail
                uploadPicture.image = thumbnail
                self.videoUrl = videoUrl
            }
          
        }
        
        if let Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = Image
            uploadPicture.image = Image
            
        }
        
        dismiss(animated: true, completion: nil)
        disableButton()
    }
    
    func thumbnailImageForFileUrl(_ fileUrl : URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake( value: 6 , timescale: 3), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
       
        
        return nil
    }
}
