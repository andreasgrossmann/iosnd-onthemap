//
//  MapViewController.swift
//  On the Map
//
//  Created by Andreas on 12/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    
    
    var students = [StudentInformation]()
    
    
    
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        
        
        
        
        
        /* Try to fetch student data */
        ParseClient.sharedInstance().fetchStudentData() { (result, error) in
            
            

                if result != nil {
                    
                    print(result)
                    
                } else {
                    
                    print(error)
                    
                }
            
            
        }
        
        
        
        
        
        
        print(students)
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    


    
    
    
    
    
    




}
