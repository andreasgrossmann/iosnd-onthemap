//
//  UdacityClient.swift
//  On the Map
//
//  Created by Andreas on 5/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session: URLSession
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Post Request
    
    func getSessionId(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool?, _ errorString: String?) -> Void) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.UdacityBaseURL + Methods.Session)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            

            

            
            /* GUARD: Was there an error? */
            guard (error == nil) else{
                print("There was an error with your request: \(error)")
                completionHandlerForSession(false, "Login Failed.")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForSession(false, "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForSession(false, "No data was returned by the request!")
                return
            }
            

            
            
            /* Strip first 5 characters off */
            
            let dataLength = data.count
            let r = 5...Int(dataLength)
            let newData = data.subdata(in: Range(r)) /* subset response data! */
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue))
            
            /* Parse data */
            
            let parsedResult = (try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            
            print(parsedResult)
            
            if let userKey = (parsedResult["account"] as? [String: Any])?["key"] as? String {
                print(userKey)
                
                completionHandlerForSession(true, nil)
                
            } else {
                
            }
        }
        task.resume()
        
        
    }
    
    
    
    // Get Request
    
//    private func getUserData(userKey: String) {
//        
//        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/\(userKey)")! as URL)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let dataLength = data?.count
//            let r = 5...Int(dataLength!)
//            let newData = data?.subdata(in: Range(r)) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue))
//        }
//        task.resume()
//        
//        
//    }
    
    
    
    
    
    // MARK: DELETE Request
    
    func deleteSession(completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil { // Handle error…
                return
            }
            
            /* Strip first 5 characters off */
            
            let dataLength = data?.count
            let r = 5...Int(dataLength!)
            let newData = data?.subdata(in: Range(r)) /* subset response data! */
            
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue))
            
            
            
            
            if let error = error {
                print(error)
                completionHandler(false, "Logout Failed.")
            } else {
                completionHandler(true, nil)
            }
            
            
            
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
    
    
}
