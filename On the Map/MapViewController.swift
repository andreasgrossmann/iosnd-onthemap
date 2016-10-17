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

    
    
    
//    var students = [StudentInformation]()
    
    
    
    
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

        
        
        
        
        
        
        /* Fetch student data */
        ParseClient.sharedInstance().fetchStudentData() { (result, error) in
            
            

                if result != nil {
                    
                    StudentModel.sharedInstance.students = StudentInformation.studentFromResult(results: result?["results"] as! [[String: AnyObject]])
                    
                    print(StudentModel.sharedInstance.students)
                    self.populateMap()
                    
                } else {
                    
                    print(error)
                    
                }
            
            
        }
        
        

        
    }
    
    
    
    
    

    
    
    
    //Function that populates the map with data
    func populateMap(){
        
        
        var annotations = [MKPointAnnotation]()
        
        /* For each student in the data */
        for s in StudentModel.sharedInstance.students {
            
            /* Get the lat and lon values to create a coordinate */
            let lat = CLLocationDegrees(s.latitude)
            let lon = CLLocationDegrees(s.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            /* Make the map annotation with the coordinate and other student data */
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(s.firstName) \(s.lastName)"
            annotation.subtitle = s.mediaURL
            
            /* Add the annotation to the array */
            annotations.append(annotation)
        }
        /* Add the annotations to the map */
        mapView.addAnnotations(annotations)
    }

    
    
    
    
    
    




}
