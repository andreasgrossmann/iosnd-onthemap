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
    
    private enum UIState { case MapString, MediaURL }
    var uiState = "MapString"
    
    
    

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
    }
    
    
    
    // MARK: Actions

    @IBAction func cancelPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submitPressed(_ sender: AnyObject) {
        
        if uiState == "MapString" {
            
            // Geolocate
            print("geolocating")
            configureUI(state: .MediaURL)
            
        } else if uiState == "MediaURL" {
            
            // Post to Parse
            print("posting to parse")
            configureUI(state: .MapString)
            
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
