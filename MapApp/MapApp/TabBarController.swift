//
//  NavigationController.swift
//  MapApp
//
//  Created by Aaron Phillips on 10/28/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController{
    
    @IBAction func logoutButton(sender: AnyObject) {
        logout()
    }
    @IBAction func addPinButton(sender: AnyObject) {
            self.performSegueWithIdentifier("LocationEntrySegue", sender: self)
            ParseClient.sharedInstance.postLocation(StudentManager.sharedInstance().currentStudentKey! ){data, error in
        }
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        ParseClient.sharedInstance.getStudentLocations(){ success, result, error in
        }
    }
    
    func logout(){
        dispatch_async(dispatch_get_main_queue()){
        UdacityClient.sharedInstance.logoutFromUdacity()
        }
    }
}