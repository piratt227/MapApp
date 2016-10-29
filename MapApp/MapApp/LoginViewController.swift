//
//  ViewController.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/21/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var udacityClient: UdacityClient!
    var parseClient: ParseClient!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        if emailTextField.text == ""{
            alertView("Error", message: "Please enter email")
        }
        else if passwordTextField.text == ""{
            alertView("Error", message: "Please enter password")
        }
        else{
            self.activityIndicatorView.startAnimating()
            loginToUdacity()
        }
    }
    
    func loginToUdacity(){
       
        UdacityClient.sharedInstance.udacityLogin(emailTextField.text!, password: passwordTextField.text!){ (success, data, error) in
            dispatch_async(dispatch_get_main_queue()){
            if success{
            UdacityClient.sharedInstance.getPublicUserData(StudentManager.sharedInstance().currentStudentKey){ success, data, error in
                }
                self.activityIndicatorView.stopAnimating()
                self.performSegueWithIdentifier("TabBarSegue", sender: self)                
            }
            else{
                dispatch_async(dispatch_get_main_queue()){
                    self.activityIndicatorView.stopAnimating()
                    self.alertView("Login Failed", message: error!)
                    }
                }
            }
        }
    }
    
    func alertView(title: String!, message: String!){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutUnwindAction(segue: UIStoryboardSegue) {}
}



