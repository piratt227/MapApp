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
    typealias parseCompletionHandler = (data: AnyObject!, error: String?) -> Void
    static let sharedInstance = ParseClient()
    var students:Student!
    
    init(){
        session = NSURLSession.sharedSession()
        students = nil
    }
    
    
    func getStudentLocations(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            self.convertDataWithCompletionHandler(data!){ (result, error) in
                
            }
        }
        task.resume()
    }
    
    func convertDataWithCompletionHandler(data: NSData, completionHandler: parseCompletionHandler){
        do{
            var parsedResult: AnyObject!
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print(parsedResult)
        }catch{
            print("Could not convert data as JSON")
        }
        
    }
}