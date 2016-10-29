//
//  ParseClient.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/22/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation

class ParseClient{
    
    var session: NSURLSession!
    typealias parseCompletionHandler = (success: Bool, data: [[String: AnyObject]], error: String?) -> Void
    static let sharedInstance = ParseClient()
    var students: Student!
    let studentManager: StudentManager!
    var studentResults: [[String:AnyObject]]!
    var studentsArray: [Student]!
    var uniqueKey: String?
    var currentStudent = StudentManager.sharedInstance().currentStudent
    
    
    init(){
        session = NSURLSession.sharedSession()
        students = nil
        studentManager = StudentManager.sharedInstance()
        uniqueKey = studentManager.currentStudentKey as! String
    }
    
    
    func getStudentLocations(completionHandler: (success: Bool, data: [[String: AnyObject]], error: String?) -> Void){
        
        let methodParameters = ["order": "-updatedAt", "limit": 100]
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation" + "\(escapedParameters(methodParameters))")!)
        //print(request)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                print("error")
                completionHandler(success: false, data: [], error: "ERROR in getStudentLocations")
                return
            }
            self.parseGetStudentLocations(data!){ (data, error) in
                completionHandler(success: true, data: data, error: "")
            }
        }
        
        task.resume()
    }
    
    func getCurrentStudent(uniqueKey: String, completionHandler: parseCompletionHandler) -> Void{
        let methodParameters = ["where": "{\"uniqueKey\": \"\(uniqueKey)\"}"]
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation" + escapedParameters(methodParameters))!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            self.parseGetCurrentStudent(data!){ data, response, error in}
            }
        task.resume()
    }
    
    func parseGetCurrentStudent(data: NSData, completionHandler: parseCompletionHandler){
        do{
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        }catch{
            print("error")
        }
    }
    
    func postLocation(currentStudentKey: String, completionHandler: (data: [String: AnyObject], error: String) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(StudentManager.sharedInstance().currentStudent["key"]!)\", \"firstName\": \"\(StudentManager.sharedInstance().currentStudent["first_name"]!)\", \"lastName\": \"\(StudentManager.sharedInstance().currentStudent["last_name"]!)\",\"mapString\": \"\(StudentManager.sharedInstance().locationText!)\", \"mediaURL\": \"\(StudentManager.sharedInstance().website!)\", \"latitude\": \(studentManager.latitude!), \"longitude\": \(studentManager.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            else{
                self.parsePostLocation(data!){ success, data, error in
                    if success{
                        completionHandler(data: data, error: "")
                    }
                    else{
                        completionHandler(data: [:], error: "error")
                    }
            }
        }
    }
        task.resume()
    }
    
    func parsePostLocation(data: NSData, completionHandler: (success: Bool,data: [String:AnyObject], error: String) -> Void){
        do{
            if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]{
                if let objectID = parsedResult["objectId"] as? String{
                    completionHandler(success: true, data: parsedResult, error: "")
                    return
                }
            }
        }catch{
            print("Could not convert data as JSON")
        }
    }
    
    func parseGetStudentLocations(data: NSData, completionHandler: (data: [[String: AnyObject]], error: String?) -> Void){
        do{
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let studentsData = parsedResult["results"] as? [[String:AnyObject]]{
            //print(studentsData)
            var studentsArray = StudentManager.sharedInstance().students
            for student in studentsData{
                studentsArray.append(Student(dictionary: student))
            }
            StudentManager.sharedInstance().students = studentsArray
                completionHandler(data: studentsData, error: "")
            }
            }catch{
                print("Could not convert data as JSON")
        }
    }
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        let newEscapedString = String()
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let newEscapedValue = escapedValue?.stringByReplacingOccurrencesOfString(":", withString: "%3A")
            let replacedSpaces = newEscapedValue?.stringByReplacingOccurrencesOfString(" ", withString: "")
            urlVars += [key + "=" + "\(replacedSpaces!)"]
            let escapedString = urlVars.joinWithSeparator("&")
            let newEscapedString = escapedString.stringByReplacingOccurrencesOfString("%20", withString: "")
        }
        return newEscapedString
    }
}