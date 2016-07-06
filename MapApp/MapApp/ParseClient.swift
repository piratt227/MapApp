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
    
    
    init(){
        session = NSURLSession.sharedSession()
        students = nil
        studentManager = StudentManager.sharedInstance()
        uniqueKey = studentManager.currentStudentKey
    }
    
    
    func getStudentLocations(completionHandler: (success: Bool, data: [[String: AnyObject]], error: String?) -> Void){
        
        let methodParameters = ["order": "-updatedAt", "limit": 100]
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation" + escapedParameters(methodParameters))!)
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
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation" + escapedParameters(methodParameters))!)
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
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
            print("get current student parsed result \(parsedResult)")
            
        }catch{
            print("error")
        }
    }
    
    
    
    func postLocation(currentStudentKey: String, completionHandler: (data: [[String: AnyObject]], error: String) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            else{
                self.parsePostLocation(data!){ success, error in
                    
            }
            }
            
    
    }

        task.resume()
    }
    
    func parsePostLocation(data: NSData, completionHandler: (success: Bool, error: String) -> Void){
        do{
            if let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]{
                if let objectID = parsedResult["objectId"] as? String{
                    completionHandler(success: true, error: "")
                    print(parsedResult)
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
    
    /*func escapedParameters(parameters: [String : AnyObject]) -> String {
        var strings = [String]()
        for (key, value) in parameters {
            let value = "\(value)"
            let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            print("escapedValue: \(escapedValue)")
            let newEscapedValue = escapedValue!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            print("escapedValue: \(newEscapedValue)")
            strings += [key + "=" + "\(newEscapedValue)"]
        }
        return (!strings.isEmpty ? "?" : "") + strings.joinWithSeparator("&")
}*/
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let newEscapedValue = escapedValue?.stringByReplacingOccurrencesOfString(":", withString: "")
            urlVars += [key + "=" + "\(newEscapedValue!)"]
        }
        print((!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&"))
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}