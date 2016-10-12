//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Andreas on 6/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
     
        // MARK: URLs
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
        
    }
    
    // MARK: Methods
    struct Methods{
        static let Session = "session"
        static let Users = "users/"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Account
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        // MARK: Session
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        
        // MARK: User Data
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
    }
    
}
