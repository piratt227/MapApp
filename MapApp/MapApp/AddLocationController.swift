//
//  AddLocationController.swift
//  MapApp
//
//  Created by Aaron Phillips on 7/5/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationController: UIViewController{
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    static let sharedInstance = AddLocationController()
    var currentStudent = StudentManager.sharedInstance().currentStudent
    var latitude: Float!
    var longitude: Float!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.hidesWhenStopped = true
    }
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        print("Submit Button Pressed")
        activityIndicatorView.startAnimating()
        StudentManager.sharedInstance().locationText = locationTextField.text!
        geocodeAddressString(locationTextField.text!)
        }
    
    
    func geocodeAddressString(addressString: String){
        CLGeocoder().geocodeAddressString(addressString){ (placemark, error) in
            if error != nil{
                self.activityIndicatorView.stopAnimating()
                dispatch_async(dispatch_get_main_queue()){
                    self.alertView("Error", message: "Could not geocode location")
                }
                return
            }
            if error == nil{
                if placemark?.count > 0{
                    if let placemark = placemark!.first{
                        StudentManager.sharedInstance().latitude = Float((placemark.location?.coordinate.latitude)!)
                        StudentManager.sharedInstance().longitude = Float((placemark.location?.coordinate.longitude)!)
                        self.activityIndicatorView.stopAnimating()
                        self.performSegueWithIdentifier("WebsiteEntrySegue", sender: self)
                    }
                }
            }
        }
    }
        func alertView(title: String!, message: String!){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
}