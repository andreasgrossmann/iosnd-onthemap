//
//  ParseClient.swift
//  On the Map
//
//  Created by Andreas on 12/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    
    
    
    
    func fetchStudentData(completionHandler: @escaping (_ result: [StudentInformation]?, _ error: String?) -> Void) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")! as URL)
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
            
            
            
//            let endGame = parsedResult["results"] as! [[String: AnyObject]]
//            for end in endGame {
//                print("@\(end)@")
//            }

            



            
            let students = StudentInformation.studentFromResult(results: parsedResult["results"] as! [[String: AnyObject]])
            



            completionHandler(students, nil)
            
            
            
            
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
