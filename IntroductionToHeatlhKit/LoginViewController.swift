//
//  LoginViewController.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.addTarget(self, action: #selector(goToSignUpPage), for: .touchUpInside)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func logIn(){
        
        FIRAuth.auth()?.signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user, error) in
            if error != nil {
                
                let showError = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: .alert)
                
                let actionError = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                showError.addAction(actionError)
                
                self.present(showError, animated: true, completion: nil)
                print(error! as NSError)
                return
            }
            self.loadHomePage()
        })
        // Maintaining Login Even When App Is Killed
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
    }
    
    
    
    func loadHomePage() {
        let controller = CustomTabBarViewController()
        present(controller, animated: true, completion: nil)
    }
    

    
    func goToSignUpPage(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {return}
        navigationController?.pushViewController(controller, animated: true)
    }
}
