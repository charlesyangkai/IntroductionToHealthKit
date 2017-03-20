//
//  ViewController.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 18/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import CoreMotion
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    var dbRef: FIRDatabaseReference!
    
    @IBOutlet weak var stepsWalked: UILabel!
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
        // Setting midnight as 00:00:00
        var cal = Calendar.current
        
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        
        let timeZone = TimeZone.ReferenceType.system
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: comps)
        
        
        
        // For Other Functionality If Completed Walking and Still Have Time
        if(CMMotionActivityManager.isActivityAvailable()){
            activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data) in
                DispatchQueue.main.async(execute: {
                    if(data?.stationary == true){
                    } else if (data?.walking == true){
                    } else if (data?.running == true){
                    } else if (data?.automotive == true){
                    }
                })
            })
        }
        
        
        if(CMPedometer.isStepCountingAvailable()){
            let fromDate = Date(timeIntervalSinceNow: -86400 * 7)
            
            self.pedoMeter.queryPedometerData(from: fromDate, to: Date(), withHandler: { (data, error) in
                print(data ?? "no data bro")
                
                DispatchQueue.main.async {
                    if(error == nil){
                        self.stepsWalked.text = "\(data?.numberOfSteps)"
                    }
                }
            })
        }
        
        
        
        self.pedoMeter.startUpdates(from: midnightOfToday!) { (data, error) in
            DispatchQueue.main.async {
                if(error == nil){
                    self.stepsWalked.text = "\(data?.numberOfSteps)"
                    
                    // Upload Step Walked Today to Firebase
                    let userID = FIRAuth.auth()?.currentUser?.uid
                    
                    let stepWalked: [String: Any] = ["StepsWalkedToday" : data?.numberOfSteps ?? "1000"]
                    self.dbRef.child("users").child(userID!).updateChildValues(stepWalked)
                    
                }
            }
        }
    }
    
    
    
    
    
    
}

