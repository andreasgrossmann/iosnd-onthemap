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
    
    func postStudentLocation(userKey: String, firstName: String, lastName: String, mediaURL: String, mapString: String, latitude: Double, longitude: Double, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
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
            
            
            completionHandler(true, nil)
            
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: GET locations posted by current user from Parse
    
    func getUserLocations(userKey: String, completionHandler: @escaping (_ success: Bool?, _ errorString: String?) -> Void) {

        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(userKey)%22%7D"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil { /* Handle error */ return }
            
            
            /* Parse data */
            
            let parsedResult = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! [String: AnyObject]
            
            
            
            // This could return multiple user locations
            
            let userLocations = parsedResult["results"] as! [[String: AnyObject]]
            
            // We'll use the last location, which would be the most recent one

            // NOTE: USE SOME IF LET HERE, SO THAT WE WON'T CRASH IF WORSE COMES TO WORSE
            
            UserInformation.latitude = userLocations.last?["latitude"] as! Double
            UserInformation.longitude = userLocations.last?["longitude"] as! Double
            UserInformation.mapString = userLocations.last?["mapString"] as! String
            UserInformation.mediaURL = userLocations.last?["mediaURL"] as! String
            UserInformation.objectId = userLocations.last?["objectId"] as! String
            
            
            completionHandler(true, nil)
            
            
            
            
            

            
            
            
            
        }
        task.resume()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: PUTing (Updating) the current user's location on Parse
    
    func updateStudentLocation(userKey: String, firstName: String, lastName: String, mediaURL: String, mapString: String, latitude: Double, longitude: Double, objectId: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(objectId)")!)
        
        print(request)
        
        request.httpMethod = "PUT"
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
            
            
            completionHandler(true, nil)
            
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
