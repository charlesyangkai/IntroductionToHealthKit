//
//  RankingsViewController.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RankingsViewController: UIViewController {
    
    var userID: String?
    var stepsWalked: String?
    var dbRef: FIRDatabaseReference!
    var friends: [User] = []
    
    // Dummy Data Friends
    let johnCena = User(name: "John Cena", stepsWalked: "3012", picture: UIImage(named: "profile")!)
    let bob = User(name: "Bob The Builder", stepsWalked: "2098", picture: UIImage(named: "profile")!)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let searchController = UISearchController(searchResultsController: nil)
        //tableView.tableHeaderView = searchController.searchBar
        dbRef = FIRDatabase.database().reference()
        userID = FIRAuth.auth()?.currentUser?.uid
        
        // Retrieving Current User Info
        dbRef.child("users").child(userID!).observe(.childAdded, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else {return}
            
            print(value)
            let currentUser = User(withDictionary: value)
            // Appending each chat
            self.appendUser(currentUser)
            self.appendUser(self.johnCena)
            self.appendUser(self.bob)
            self.tableView.reloadData()
        })
        
        tableView.dataSource = self
        
        navigationItem.title = "R A N K I N G S"
        // Configure autolayout for row height
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func appendUser(_ user: User){
        friends.append(user)
    }
    
}

extension RankingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("you have \(friends.count) friends")
        return friends.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
            else {
                return UITableViewCell()
        }
        
        let rank = indexPath.row + 1
        let user = friends[indexPath.row]
        
        cell.nameLabel.text = user.name
        cell.stepsLabel.text = user.stepsWalked
        cell.rankingLabel.text = "#\(rank)"
        
        if let imageUrl = user.profilePicture{
            if let data = try? Data(contentsOf: imageUrl) {
                cell.pictureIV.image = UIImage(data: data)
            }
        }else if let picture = user.picture{
            cell.pictureIV.image = picture
        }else{
            print("nigga damn")
        }
        
        
        
        return cell
    }
    
}
