//
//  ParseClient.swift
//  On the Map
//
//  Created by Andreas on 12/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    
    
    // MARK: GET Student Locations
    
    func getStudentLocations(completionHandler: @escaping (_ result: [String: AnyObject]?, _ error: String?) -> Void) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")! as URL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            if error != nil { // Handle error...
                return
            }
            
            
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else{
                print("There was an error with your request: \(error)")
                completionHandler(nil, "...")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandler(nil, "...")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(nil, "...")
                return
            }
            
            
            
            
            /* Parse data */
            
            let parsedResult = (try! JSONSerialization.jsonObject(with: data, options: .allowFragments)) as! [String: AnyObject]
            
            



            completionHandler(parsedResult, nil)
            
            
            
            
        }
        task.resume()
        
        
    }
    
    
    
    
    
    
    
    
    // MARK: POST User Location
    
    func postStudentLocation(userKey: String, firstName: String, lastName: String, mediaURL: String, mapString: String, latitude: Double, longitude: Double, completionHandler: (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")! as URL)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
