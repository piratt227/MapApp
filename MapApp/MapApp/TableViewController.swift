//
//  TableViewController.swift
//  MapApp
//
//  Created by Aaron Phillips on 7/1/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var students: [Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        students = StudentManager.sharedInstance().students
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = students?.count{
            return rows
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("CellReuseID")
        if let students = self.students{
        let student = students[indexPath.row]
        cell.textLabel!.text = student.firstName
        }
        return cell
    
    }
}