//
//  UdacityClient.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/21/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation

class UdacityClient{
    
    var session: NSURLSession!
    var udacity: NSDictionary!

    
    static let sharedInstance = UdacityClient()
    
    // Udacity Video - Type Alias Example - Grand Central Dispatch - Closures Reloaded
    typealias udacityCompletionHandler = (data: NSDictionary?, error: String?) -> Void
    
    init(){
        session = NSURLSession.sharedSession()
    }
    
    func udacityLogin(email: String!, password: String!, completionHandler: udacityCompletionHandler){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(email)\", \"password\" : \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            guard (error == nil) else{
                print("udacityLogin task error: \(error)")
                completionHandler(data: nil, error: "Error")
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandler(data: nil, error: "Error")
                return
            }
            guard (data != nil) else{
                print("udacityLogin data is nil")
                completionHandler(data: nil, error: "Error")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            self.convertDataWithCompletionHandler(newData){ (data, error) in
            }
            completionHandler(data: self.udacity, error: "")
            print(self.udacity)
            
        }
        task.resume()
    }
    
    func convertDataWithCompletionHandler(data: NSData, completionHandler: udacityCompletionHandler){
        do{
            var parsedResult: AnyObject!
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            udacity = parsedResult as? NSDictionary
        }catch{
            print("Could not convert data as JSON")
        }
        
    }
    
}