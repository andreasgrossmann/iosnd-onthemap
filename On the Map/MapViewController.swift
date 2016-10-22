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

        
        
        
        // NOTE: WHEN THE STUDENT DATA TAKES A BIT LONGER TO LOAD (IS NOT AVAILABLE WHEN THE MAP VIEW APPEARS FOR EXAMPLE)
        // IT WILL SHOW ON THE MAP VIEW ONLY AFTER ONE WENT TO THE TABLE VIEW (THE NEXT TIME THE VIEW APPEARS)
        // I THINK THE PROBLEM MIGHT BE THAT IT'S TRYING TO POPULATE THE MAP BEFORE THE STUDENT DATA FINISHED FETCHING
        // SO WE WOULD NEED A CALLBACK TO RESOLVE THIS...?
        // OR MAYBE THIS METHOD SHOULDN'T BE IN THE HELPER FILE...?
        
        // RE(POPULATING) THE MAP AND REFRESHING THE TABLE NEEDS TO BE PART OF UPDATING ANYWAY, OTHERWISE WE'RE ONLY UPDATING THE DATA MODEL
        // WE COULD JUST CALL POPULATEMAP() AND RELOADTABLEDATA() WHEN REFRESH IS TAPPED
        
        
        Helpers.sharedInstance().fetchStudentData() { (success, error) in
            
            if success {
                
                // Remove map annotations and repopulate
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.populateMap()
                }
                
            } else {
                
                // error
                
            }
            
        }
        
        

        
        

        
    }
    
    
    
    
    
    // MARK: Actions
    
    @IBAction func logoutPressed(_ sender: AnyObject) {
        
        UdacityClient.sharedInstance().deleteSession() { (success, errorString) in
            if success {
                
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(viewController, animated: true, completion: nil)
                
            } else {
                
                print("Failed to logout")
                
            }
        }
        
    }
    
    @IBAction func refreshPressed(_ sender: AnyObject) {
        
        Helpers.sharedInstance().fetchStudentData() { (success, error) in
            
            if success {
                
                // Remove map annotations and repopulate
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.populateMap()
                }
                
            } else {
                
                // error
                
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
        self.mapView.addAnnotations(annotations)

        
    }

    
    
    
    
    
    
    // MARK: Open annotation's mediaURL in browser when tapped
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Make sure URL is in correct format
        let mediaURL = URL(string: Helpers.sharedInstance().formatURL(url: ((view.annotation?.subtitle)!)!))
        UIApplication.shared.open(mediaURL!, options: [:], completionHandler: nil)
    }
    

    
    
    
    




}
