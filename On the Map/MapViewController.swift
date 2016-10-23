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
    
    

    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Check Parse if current user has posted a location before
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ParseClient.sharedInstance().getUserLocations(userKey: UserInformation.userKey) { (success, error) in
            
            if success! {
                
                // If user is already on map, center map on coordinates they posted
                
                if UserInformation.latitude != 0.00 && UserInformation.longitude != 0.00 {
                    
                    performUIUpdatesOnMain {
                        let location = CLLocationCoordinate2D(latitude: UserInformation.latitude, longitude: UserInformation.longitude)
                        let span = MKCoordinateSpanMake(10, 10)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapView.setRegion(region, animated: true)
                    }
                    
                    
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

            } else {

                // error

            }
            
        }
        
        
        

        // Get student data from Parse
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Helpers.sharedInstance().fetchStudentData() { (success, error) in
            
            if success {
                
                // Remove map annotations and repopulate
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.populateMap()
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            } else {
                
                // error
                
            }
            
        }
        
        

        
        

        
    }
    
    
    
    
    
    // MARK: Actions
    
    @IBAction func logoutPressed(_ sender: AnyObject) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        UdacityClient.sharedInstance().deleteSession() { (success, errorString) in
            if success {
                
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(viewController, animated: true, completion: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            } else {
                
                print("Failed to logout")
                
            }
        }
        
    }
    
    @IBAction func refreshPressed(_ sender: AnyObject) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Helpers.sharedInstance().fetchStudentData() { (success, error) in
            
            if success {
                
                // Remove map annotations and repopulate
                performUIUpdatesOnMain {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.populateMap()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
