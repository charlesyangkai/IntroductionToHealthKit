//
//  SignUpViewController.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    var dbRef: FIRDatabaseReference!
    var profilePictureURL: URL?
    var imageSelected: UIImage?

    @IBOutlet weak var imageView: UIImageView!{
        didSet {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.clipsToBounds = true
            
            return
        }
    }

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(false, animated: false)
        dbRef = FIRDatabase.database().reference()
    }
    
    
    
    func signUp(){
        
        FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user,error) in
            if error != nil{
                print(error! as NSError)
                return
            }
            
            
            // Step 1. Defining the value, what kind of child users shoudl have
            var userDictionary : [String: Any] = ["name" : self.nameTF.text ?? "Charles Lee Yang Kai", "age": self.ageTF.text ?? "23", "email" : self.emailTF.text ?? "charleslee94@hotmail.com"]
            
            self.uploadProfilePicture(image: self.imageSelected!)
            
            // Convert profile picture url to string
            if let urlString = self.profilePictureURL?.absoluteString{
                // Dictionary with key image stores urlString as value
                userDictionary["profilePicture"] = urlString 
                
            }
            
            // Step 2. Definining the key/id
            guard let validUserID = user?.uid else {return}
            
            
            // Step 3. Adding the child values [key: value]
            self.dbRef.child("users").updateChildValues([validUserID: userDictionary])
            
            self.showCompleteAlert()
        })
    }
    
    
    
    func uploadProfilePicture(image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        
        // Giving stored data a type of data
        metadata.contentType = "image/jpeg"
        
        // Giving a name to profilePicture selected
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        let convertedTimeStamp = timestamp.replacingOccurrences(of: ".", with: "")
        let profilePictureName = ("image \(convertedTimeStamp).jpeg")
        
        
        // Making sure there is a profilePicture before proceeding, if nil then return
        guard let profilePictureData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        // Uploading image to firebase storage
        storageRef.child(profilePictureName).put(profilePictureData, metadata: metadata) { (meta, error) in
            
            // Returning to chat by dismissing current view controller
            self.dismiss(animated: true, completion: nil)
            
            if error != nil {
                print("Error uploading image to firebase")
                return
            }
            
            if let downloadUrl = meta?.downloadURL(){
                // Step 1 of setting image url string
                self.profilePictureURL = downloadUrl
            }
        }
    }
    
    
    func showCompleteAlert() {
        let alert = UIAlertController(title: "Sign up complete!", message: "Proceed to log in.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
            //let signUpComplete = self.storyboard?.instantiateViewController(withIdentifier: "UserLogInController") as? UserLogInController
            // self.navigationController?.pushViewController(signUpComplete!, animated: true)
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
            imageSelected = selectedImageFromPicker
        }
        
        dismiss(animated: true, completion: nil)
    }
}


