//
//  StudentManager.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/21/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation

class StudentManager{
    
    var students: [Student] = [Student]()
    var currentStudent: Student?
    var currentStudentKey: String?
    
// Shared Instance **************************************************************************************
// ******************************************************************************************************
    class func sharedInstance() -> StudentManager{
        struct Singleton {
            static var sharedInstance = StudentManager()
        }
        return Singleton.sharedInstance
    }
}