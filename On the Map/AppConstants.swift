//
//  AppConstants.swift
//  On the Map
//
//  Created by Andreas on 17/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    
    // MARK: UI
    
    struct UI {
        static let LoginColorTop = UIColor(red: 1.0, green: 0.6, blue: 0.043, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 1.0, green: 0.435, blue: 0.0, alpha: 1.0).cgColor
        static let UdacityBlue = UIColor(red: 0.01, green: 0.70, blue: 0.89, alpha: 1.0)
        static let UdacityGrey = UIColor(red: 0.917, green: 0.917, blue: 0.917, alpha: 1.0)
    }
    
    // MARK: Alerts
    
    struct Alerts {
        static let OverwriteTitle = "Overwrite Location?"
        static let OverwriteMessage = "You've already posted a pin. Would you like to overwrite it?"
        static let LoginTitle = "Login Error"
    }
    
    // MARK: AlertActions
    
    struct AlertActions {
        static let Overwrite = "Overwrite"
        static let Cancel = "Cancel"
        static let gotIt = "Got it"
    }
    
    // MARK: Errors
    
    struct Errors {
        static let UserPassEmpty = "Username or password empty."
        static let URLEmpty = "Please enter a URL"
        static let StudentAndPlacemarkEmpty = "Student and placemark not initialized."
        static let MapStringEmpty = "Please enter a location"
        static let CouldNotGeocode = "Could not geocode the string."
        static let NoLocationFound = "No location found."
        static let PostStudentLocationFailed = "Student location could not be posted."
        static let CannotOpenURL = "Cannot open URL."
        static let CouldNotUpdateStudentLocations = "Could not update student locations."
    }
}
