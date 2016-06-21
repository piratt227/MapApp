//
//  UdacityClient.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/21/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation

class UdacityClient{
    
    var session: NSURLSession
    
    static let sharedInstance = UdacityClient()
    var userKey: String = ""
    
    // Udacity Video - Type Alias Example - Grand Central Dispatch - Closures Reloaded
    typealias udacityCompletionHandler = (data: [String: AnyObject]?, error: String?) -> Void
    
    init(){
        session = NSURLSession.sharedSession()
        var udacityLoginDictionary: [String: AnyObject?]

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
                print(data)
                print(self.userKey)
            }
            
        }
        task.resume()
    }
    
    func convertDataWithCompletionHandler(data: NSData, completionHandler: udacityCompletionHandler){
        do{
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let account = parsedResult["account"]{
                if let key = account!["key"]{
                    let registered = account!["registered"] as? Bool
                    let udacityLoginDictionary = ["key": key, "registered": registered]
                    userKey = account!["key"]
                    completionHandler(data: ["key":key!], error: "error")
                    print (udacityLoginDictionary)
                }
            }
        }catch{
            print("Could not convert data as JSON")
        }
        
    }
    
}