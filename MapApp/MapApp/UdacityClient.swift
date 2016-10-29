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
    var user: NSDictionary!
    var studentManager = StudentManager.sharedInstance()
    
    static let sharedInstance = UdacityClient()
    
    // Udacity Video - Type Alias Example - Grand Central Dispatch - Closures Reloaded
    typealias udacityCompletionHandler = (success: Bool, data: NSDictionary?, error: String?) -> Void
    
    init(){
        session = NSURLSession.sharedSession()
    }
    
    func udacityLogin(email: String!, password: String!, completionHandler: udacityCompletionHandler){
        var errorString: String!
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(email)\", \"password\" : \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            guard (error == nil) else{
                errorString = ("Internet connection appears to be offline")
                completionHandler(success: false, data: nil, error: errorString!)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                errorString = ("Incorrect Email and/or Password \n Try Again")
                completionHandler(success: false, data: nil, error: errorString!)
                return
            }
            guard (data != nil) else{
                errorString = ("No data was returned from request")
                completionHandler(success: false, data: nil, error: errorString!)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            self.convertDataWithCompletionHandler(newData){ (success, data, error) in
            }
            completionHandler(success: true, data: self.udacity, error: "")
        }
        task.resume()
    }

	func convertDataWithCompletionHandler(data: NSData, completionHandler: udacityCompletionHandler) -> String {
		do {
			var parsedResult: AnyObject!
			parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
			if let account = parsedResult["account"] {
				if let uniqueKey = account!["key"] {
					StudentManager.sharedInstance().currentStudentKey = uniqueKey as! String
				}
			}
		} catch {
			print("Could not convert data as JSON")
		}
		return StudentManager.sharedInstance().currentStudentKey
	}
    
    func getPublicUserData(uniqueKey: String!, completionHandler: udacityCompletionHandler){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(StudentManager.sharedInstance().currentStudentKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            self.parseGetPublicUserData(newData){ success, data, error in
            }
            completionHandler(success: true, data: self.user, error: "")
        }
        task.resume()
    }
    
    func parseGetPublicUserData(data: NSData, completionHandler: udacityCompletionHandler){
        do{
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
            if let user = parsedResult["user"]{
                StudentManager.sharedInstance().currentStudent = user as! [String : AnyObject]
                if let lastName = user["last_name"]!{
                    if let firstName = user["first_name"]!{
                        if let uniqueKey = user["key"]!{
                        }
                    }
                }
                completionHandler(success: true, data: user as! [String: AnyObject], error: "")
            }
        }catch{
            print("Error parsing public user data")
        }
    }
    
    func logoutFromUdacity(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            do{
                let parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                print(parsedResult)
            }
            catch{
                print("logout error")
            }
        }
        task.resume()
    }
    
}