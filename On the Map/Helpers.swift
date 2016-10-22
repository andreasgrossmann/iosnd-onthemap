//
//  Helpers.swift
//  On the Map
//
//  Created by Andreas on 18/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation
import UIKit

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
    
    
    
    
    

    
    
    
    
    
    
    // remove spaces from url and add missing http:
    func formatURL(url: String) -> String {
        var formattedURL = url
        if formattedURL.characters.first != "h"  && formattedURL.characters.first != "H"{
            formattedURL = "http://\(formattedURL)"
        }
        return String(formattedURL.characters.filter { !" ".characters.contains($0) })
    }
    
    
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Helpers {
        struct Singleton {
            static var sharedInstance = Helpers()
        }
        return Singleton.sharedInstance
    }
    
}








extension UIViewController {
    
    // MARK: Display Alert
    
    func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        performUIUpdatesOnMain {
            
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppConstants.AlertActions.gotIt, style: .default, handler: completionHandler))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
