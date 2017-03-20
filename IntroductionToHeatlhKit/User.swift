//
//  User.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import Foundation
import UIKit


class User{
    
    var name: String?
    var stepsWalked: String?
    var picture: UIImage?
    var profilePicture: URL?
    var age: String?
    
    init(name: String, stepsWalked: String, picture: UIImage){
        self.name = name
        self.stepsWalked = stepsWalked
        self.picture = picture
    }
    
    init(withDictionary dictionary: [String:Any]){
        
        name = dictionary["name"]as? String
        age = dictionary["age"]as? String
        stepsWalked = dictionary["stepsWalked"] as? String
        if let profilePictureURL = dictionary["profilePicture"] as? String{
            profilePicture = URL(string: profilePictureURL)
            
        }
    }
    
}
