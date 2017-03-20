//
//  ProfileViewController.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    var userID: String?
    var dbRef: FIRDatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!{
        didSet{
            logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        }
    }
    @IBOutlet weak var viewProgressButton: UIButton!{
        didSet{
            viewProgressButton.addTarget(self, action: #selector(viewProgress), for: .touchUpInside)
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        userID = FIRAuth.auth()?.currentUser?.uid
        
        // Retrieving Current User Info
        dbRef.child("users").child(userID!).observe(.childAdded, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else {return}
            
            print(value)
            let currentUser = User(withDictionary: value)
            
            self.nameLabel.text = currentUser.name
            self.ageLabel.text = currentUser.age
            if let imageUrl = currentUser.profilePicture{
                if let data = try? Data(contentsOf: imageUrl) {
                    self.imageView.image = UIImage(data: data)
                }
            }
        })
    }
    
    
    func logOut(){
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.handleLogout()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "navController")
            as? UINavigationController
        present(controller!, animated: true, completion: nil)
        
        //Maintaining Login
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func viewProgress(){
        
    }
    
    
    
}
