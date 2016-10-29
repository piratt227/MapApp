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
    var currentStudent: [String: AnyObject]!
    var currentStudentKey: String!
    var locationText: String!
    var latitude: Float!
    var longitude: Float!
    var website: String!
    var myStudent: Student!
    
// Shared Instance **************************************************************************************
// ******************************************************************************************************
    class func sharedInstance() -> StudentManager{
        struct Singleton {
            static var sharedInstance = StudentManager()
        }
        return Singleton.sharedInstance
    }
}