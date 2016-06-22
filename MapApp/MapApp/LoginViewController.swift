//
//  ViewController.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/21/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var udacityClient: UdacityClient!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        print("Login Button Pressed")
        loginToUdacity()
        }
    
    func loginToUdacity(){
        UdacityClient.sharedInstance.udacityLogin(emailTextField.text!, password: passwordTextField.text!){ (data, error) in
            if data != nil{
                ParseClient.sharedInstance.getStudentLocations()
            }
        }
    }
}
