//
//  StudentInformation.swift
//  On the Map
//
//  Created by Andreas on 5/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var createdAt: NSString
    var firstName: String
    var lastName: String
    var latitude: Float
    var longitude: Float
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: NSString
    
    //constructing student from dictionary
    init?(dictionary: [String: AnyObject]) {
        guard let unique = dictionary["uniqueKey"] as? String else { return nil }
        uniqueKey = unique
        
        createdAt = dictionary["createdAt"] as! NSString
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Float
        longitude = dictionary["longitude"] as! Float
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
//        uniqueKey = dictionary["uniqueKey"] as! String
        updatedAt = dictionary["updatedAt"] as! NSString
        
    }
    
    static func studentFromResult(results: [[String: AnyObject]]) -> [StudentInformation] {
        
//        print(type(of: results))
//        print(results)

        
        var students = [StudentInformation]()

        for result in results {

            if let studentInfo = StudentInformation(dictionary: result) {
                students.append(studentInfo)
            
//            students.append(StudentInformation(dictionary: result))
            
//            print(type(of: result))
            }
        
        
        }
        
//        print(students)
        return students
    
    }

}
