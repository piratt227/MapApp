//
//  TableViewController.swift
//  MapApp
//
//  Created by Aaron Phillips on 7/1/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITabBarDelegate{
    
    var parseClient = ParseClient.sharedInstance
    @IBOutlet weak var studentTable: UITableView!
    var students = StudentManager.sharedInstance().students
    
    override func viewDidLoad() {
        super.viewDidLoad()
        students = StudentManager.sharedInstance().students
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellReuseID", forIndexPath: indexPath)
        let student = students[indexPath.row]
        if student.lastName == ""{
            cell.textLabel?.text = "Name Missing"
        }
        else{
        cell.textLabel?.text = (student.firstName! + " " + student.lastName!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        let application = UIApplication.sharedApplication()
        let urlString = student.mediaURL
        if urlString!.hasPrefix("www"){
            let urlString = ("http://" + urlString!)
            let url = NSURL(string: urlString)
            if application.canOpenURL(url!){
                application.openURL(url!)
            }
        }
        else if urlString!.hasPrefix("http://") || urlString!.hasPrefix("https://"){
            let url = NSURL(string: urlString!)
            if application.canOpenURL(url!){
                application.openURL(url!)
            }
        }
        else{
            self.alertView("Error", message: "Invalid URL")
        }
    }
    
    
    
    
    func loadStudents(){
        ParseClient.sharedInstance.getStudentLocations(){ (success, result, error) in
        }
    }
    
    func alertView(tite: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
        }

}
