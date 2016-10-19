//
//  Helpers.swift
//  On the Map
//
//  Created by Andreas on 18/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

class Helpers: NSObject {
    
    
    

    // Completion handler for this ensures that app won't attempt to populate map or table view until student data is available
    
    func fetchStudentData(completionHandler: @escaping (_ success: Bool, _ error: Bool) -> Void) {
        
        /* Fetch student data */
        ParseClient.sharedInstance().getStudentLocations() { (result, error) in
            
            
            
            if result != nil {
                
                StudentModel.sharedInstance.students = StudentInformation.studentFromResult(results: result?["results"] as! [[String: AnyObject]])
                
                //                    print(StudentModel.sharedInstance.students)
                
                completionHandler(true, false)
                
                
            } else {
                
                print(error)
                
            }
            
            
        }
        
        
    }
    
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Helpers {
        struct Singleton {
            static var sharedInstance = Helpers()
        }
        return Singleton.sharedInstance
    }
    
}
