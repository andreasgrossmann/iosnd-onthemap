//
//  TableViewController.swift
//  On the Map
//
//  Created by Andreas on 12/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Helpers.sharedInstance().fetchStudentData() { (success, error) in
            
            if success {
                
                // Reload table data
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            } else {
                
                // error
                
            }
            
        }
    }
    
    
    
    
    // Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.sharedInstance.students.count
    }
    
    
    
    // Configure table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let studentTable = StudentModel.sharedInstance.students[indexPath.row]
        
        
        
        cell.textLabel?.text = studentTable.firstName + " " + studentTable.lastName
        cell.detailTextLabel?.text = studentTable.mapString.capitalized
    
        
        return cell
    }
    
    
    // Tap on table cell opens student's weblink
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let thisRowStudent = StudentModel.sharedInstance.students[indexPath.row]
//        print(thisRowStudent.uniqueKey)
        
        // Make sure URL is in correct format
        if let url = URL(string: Helpers.sharedInstance().formatURL(url: StudentModel.sharedInstance.students[indexPath.row].mediaURL)) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        
        
    }
    
    
    
    
    
    
    
    // Swipe to delete
    // WE NEED TO CHECK THAT THE USER CAN ONLY DELETE THEIR OWN ENTRIES
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let thisRowStudent = StudentModel.sharedInstance.students[indexPath.row]
        
        if thisRowStudent.uniqueKey == UserInformation.userKey {
        
            return true
            
        } else {
            
            return false
            
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        
        if editingStyle == .delete {
            
            // Identify student for this row
            
            let thisRowStudent = StudentModel.sharedInstance.students[indexPath.row]
            
            // Remove the row

            StudentModel.sharedInstance.students.remove(at: indexPath.row)
            
            
            
            // Remove student from Parse database
            
            performUIUpdatesOnMain {
                ParseClient.sharedInstance().deleteStudentLocation(objectId: thisRowStudent.objectId) { (success, errorString) in
                    if success {
                        
                        // success
                        
                        // Reset user information locally
                        // There's only one API call in map view to check whether current user has posted before
                        // This is to keep track of things internally
                        
                        UserInformation.latitude = 0.00
                        UserInformation.longitude = 0.00
                        
                        UserInformation.mapString = ""
                        UserInformation.mediaURL = ""
                        UserInformation.objectId = ""
                        

                        
                        
                    } else {
                        // error
                    }
                }
                
                tableView.reloadData()
                
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
                
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            } else {
                
                // error
                
            }
            
        }
        
    }
    



}
