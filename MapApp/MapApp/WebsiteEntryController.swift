//
//  WebsiteEntryController.swift
//  MapApp
//
//  Created by Aaron Phillips on 10/25/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit


class WebsiteEntryController: UIViewController{
    
    @IBOutlet weak var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    @IBAction func submitButton(sender: AnyObject) {
        StudentManager.sharedInstance().website = websiteTextField.text!
        StudentManager.sharedInstance().currentStudent["mediaURL"] = websiteTextField.text!
        ParseClient.sharedInstance.postLocation(StudentManager.sharedInstance().currentStudentKey!){ data, error in
            if error != ""{
                print("Error posting data")
                
                /////// PUT ALERT HERE ////////////
                
            }
            else{
                print("Posting Successful")
            }
        }
    }
}