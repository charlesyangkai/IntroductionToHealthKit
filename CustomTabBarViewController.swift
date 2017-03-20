//
//  CustomTabBarViewController.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View Controllers linked to Tab Bars
        setViewControllers([createHomeViewController(imageName: "shoe"), createRankingsViewController(imageName: "rankings"), createProfileViewController(imageName: "profile")], animated: true)
    }
    
    
    func createHomeViewController(imageName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        let navController = UINavigationController(rootViewController: homeViewController)
        let tabbarItem = UITabBarItem(title: "Shoe", image: UIImage(named:imageName), selectedImage:nil)
        navController.tabBarItem = tabbarItem
        //navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createRankingsViewController(imageName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rankingsViewController = storyboard.instantiateViewController(withIdentifier: "RankingsViewController")
        let navController = UINavigationController(rootViewController: rankingsViewController)
        let tabbarItem = UITabBarItem(title: "Rankings", image: UIImage(named:imageName), selectedImage:nil)
        navController.tabBarItem = tabbarItem
        //navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createProfileViewController(imageName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        let navController = UINavigationController(rootViewController: profileViewController)
        let tabbarItem = UITabBarItem(title: "Profile", image: UIImage(named:imageName), selectedImage:nil)
        navController.tabBarItem = tabbarItem
        return navController
    }
    
    
}
