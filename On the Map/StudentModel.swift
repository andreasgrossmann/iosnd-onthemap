//
//  StudentModel.swift
//  On the Map
//
//  Created by Andreas on 31/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

// MARK: Student model

class StudentModel {
    
    var students: [StudentInformation] = []
    
    static let sharedInstance = StudentModel()
}
