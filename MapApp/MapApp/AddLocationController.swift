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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        geocodeAddressString(locationTextField.text!){ data, error in
            var error: NSError
        }
    }
    
    func geocodeAddressString(addressString: String, completionHandler: CLGeocodeCompletionHandler){
        var placemark: NSArray
    }
    
}