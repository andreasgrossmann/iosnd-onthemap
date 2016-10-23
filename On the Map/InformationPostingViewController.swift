//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Andreas on 17/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    
    
    // MARK: UI State
    
    enum UIState { case MapString, MediaURL }
    var uiState = "MapString"
    
    
    // MARK: Properties
    
    private var placemark: CLPlacemark? = nil
    
    
    

    // MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var postingMapView: MKMapView!
    @IBOutlet weak var topSectionView: UIView!
    @IBOutlet weak var midSectionView: UIView!
    @IBOutlet weak var bottomSectionView: UIView!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI(state: .MapString)
        
        // Required to automatically prefix hyperlinks with https
        mediaURLTextField.delegate = self
        
        
        print(UserInformation.firstName + " " + UserInformation.lastName + ", " + UserInformation.userKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

        if UserInformation.mapString.isEmpty {
            
            print("This user hasn't posted before")
            
        } else {
            
            self.displayAlert(message: "Looks like you already posted a location. If you continue, we'll update your previous location.")
            
            performUIUpdatesOnMain {
                self.mapStringTextField.text = UserInformation.mapString.capitalized
            }
            
        }
        
        
        
    }
    
    
    
    // MARK: Actions

    @IBAction func cancelPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    // MARK: Validate URL
    func validateURL(_ url: String) -> Bool {
        let pattern = "^(https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        if url.range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    // MARK: Automatically prefix hyperlinks with https
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            textField.text = "https://"
        }
    }
    
    
    
    
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        
        if uiState == "MapString" {
            
            // Geolocate
            
            
            
            
            // check for empty string
            if mapStringTextField.text!.isEmpty {
                displayAlert(message: AppConstants.Errors.MapStringEmpty)
                return
            }
            
            
            
            
            
            // add placemark

            performUIUpdatesOnMain {
                
                
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = self.view.center
                activityIndicator.startAnimating()
                self.view.addSubview(activityIndicator)

                
                
                let geocoder = CLGeocoder()
          
                geocoder.geocodeAddressString(self.mapStringTextField.text!, completionHandler: { (results, error) in
                    if let _ = error {
                        activityIndicator.stopAnimating()
                        self.displayAlert(message: AppConstants.Errors.CouldNotGeocode)
                    }
                    else if (results!.isEmpty){
                        activityIndicator.stopAnimating()
                        self.displayAlert(message: AppConstants.Errors.NoLocationFound)
                    } else {
                        activityIndicator.stopAnimating()
                        self.placemark = results![0]
                        self.configureUI(state: .MediaURL)
                        self.postingMapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
                        
                        
                        
                        // Try to prefill the mediaURL field
                        // If we find a mediaURL, they have posted before
                        // Change submit button title accordingly
                        
                        if UserInformation.mediaURL != "" {
                            
                            performUIUpdatesOnMain {
                                self.mediaURLTextField.text = UserInformation.mediaURL
                                self.submitButton.setTitle("UPDATE", for: UIControlState.normal)
                            }
                            
                        }
                        
                        
                        
                    }
                })
                
                
                
                
                
                
            }
            
            
            print(UserInformation.objectId)
            
            
            
            

            
        } else if uiState == "MediaURL" {
            
            
            // NOTE THIS WILL ONLY RUN WHEN YOU PRESS SUBMIT ON THE MEDIA URL VIEW !!!
            

            
            if UserInformation.objectId.isEmpty {
                
                // User hasn't posted before
                // Post to Parse
                
                
                // check for empty string
                if mediaURLTextField.text!.isEmpty {
                    displayAlert(message: AppConstants.Errors.URLEmpty)
                    return
                }
                
                if validateURL(mediaURLTextField.text!) == false {
                    displayAlert(message: "Please enter a valid URL.")
                    return
                }
                
                
                
                
                
                
                // Post user location to Parse
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                performUIUpdatesOnMain {
                    ParseClient.sharedInstance().postStudentLocation(userKey: UserInformation.userKey, firstName: UserInformation.firstName, lastName: UserInformation.lastName, mediaURL: self.mediaURLTextField.text!, mapString: self.mapStringTextField.text!, latitude: self.placemark!.location!.coordinate.latitude, longitude: self.placemark!.location!.coordinate.longitude) { (success, errorString) in
                        if success {
                            
                            // success
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                            
                            // Set user's location coordinates to center the map on when view controller is dismissed
                            UserInformation.latitude = (self.placemark!.location!.coordinate.latitude)
                            UserInformation.longitude = (self.placemark!.location!.coordinate.longitude)
                            
                            UserInformation.mapString = self.mapStringTextField.text!
                            UserInformation.mediaURL = self.mediaURLTextField.text!

                            
                            
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            
                        } else {
                            // error
                        }
                    }
                }
                
                
            } else {
                

                // User has posted before
                // Update their information on Parse

                
                
                
                // Check URL again as user could have tampered with it after it was prefilled
                
                if mediaURLTextField.text!.isEmpty {
                    displayAlert(message: AppConstants.Errors.URLEmpty)
                    return
                }
                
                if validateURL(mediaURLTextField.text!) == false {
                    displayAlert(message: "Please enter a valid URL.")
                    return
                }

                // WE SHOULD PROBABLY CHECK FOR PRESENCE OF objectId SOMEWHERE UP HERE BEFORE...?
                // Update user location on Parse
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                performUIUpdatesOnMain {
                    ParseClient.sharedInstance().updateStudentLocation(userKey: UserInformation.userKey, firstName: UserInformation.firstName, lastName: UserInformation.lastName, mediaURL: self.mediaURLTextField.text!, mapString: self.mapStringTextField.text!, latitude: self.placemark!.location!.coordinate.latitude, longitude: self.placemark!.location!.coordinate.longitude, objectId: UserInformation.objectId) { (success, errorString) in
                        if success {
                            
                            // success
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                            
                            // Set user's location coordinates to center map on when view controller is dismissed
                            // There's only one API call in map view to check whether current user has posted before
                            // This is to keep track of things internally
                            
                            UserInformation.latitude = (self.placemark!.location!.coordinate.latitude)
                            UserInformation.longitude = (self.placemark!.location!.coordinate.longitude)
                            
                            UserInformation.mapString = self.mapStringTextField.text!
                            UserInformation.mediaURL = self.mediaURLTextField.text!
                            
                            
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            
                        } else {
                            // error
                        }
                    }
                }
                
                
                
                
                
                
            }
            
            
            
            
            
            

            
        }
            
            

        
    }
        

    
    
    
    
    
    
    
    
    

    
    
    
    // User clicks button at the bottom
    // What's the UI state, mapString or mediaURL...?
    // Needs variable that tracks UI state and function to configure it
    // Call the appropriate method
    
    
    private func configureUI(state: UIState, location: CLLocationCoordinate2D? = nil) {
        
        UIView.animate(withDuration: 1.0) {
            switch(state) {
            case .MapString:
                self.uiState = "MapString"
                self.postingMapView.isHidden = true
                self.topSectionView.backgroundColor = AppConstants.UI.UdacityGrey
                self.midSectionView.backgroundColor = AppConstants.UI.UdacityBlue
                self.bottomSectionView.backgroundColor = AppConstants.UI.UdacityGrey
                self.mediaURLTextField.isHidden = true
                self.mapStringTextField.isHidden = false
                self.cancelButton.setTitleColor(AppConstants.UI.UdacityBlue, for: .normal)
                self.submitButton.setTitle("Find on the Map", for: UIControlState.normal)
                self.submitButton.setTitleColor(AppConstants.UI.UdacityBlue, for: .normal)
                self.submitButton.backgroundColor = UIColor.clear
                self.studyingLabel.isHidden = false
            case .MediaURL:
                if let location = location {
                    self.postingMapView.centerCoordinate = location
                }
                self.uiState = "MediaURL"
                self.postingMapView.isHidden = false
                self.topSectionView.backgroundColor = AppConstants.UI.UdacityBlue
                self.midSectionView.backgroundColor = UIColor.clear
                self.bottomSectionView.backgroundColor = UIColor.clear
                self.mediaURLTextField.isHidden = false
                self.mapStringTextField.isHidden = true
                self.cancelButton.setTitleColor(UIColor.white, for: .normal)
                self.submitButton.setTitle("Submit", for: UIControlState.normal)
                self.submitButton.setTitleColor(UIColor.white, for: .normal)
                self.submitButton.backgroundColor = AppConstants.UI.UdacityBlue
                self.studyingLabel.isHidden = true
            }
        }
    }
    
    


}

