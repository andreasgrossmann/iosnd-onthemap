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
        
        tableView.reloadData()
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
        cell.detailTextLabel?.text = studentTable.mediaURL
    
        
        return cell
    }
    
    
    // Tap on table cell opens student's weblink
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(StudentModel.sharedInstance.students[indexPath.row].mediaURL) // Note: This won't open URLs that are missing the http(s):// prefix
        // There should be some sort of notification when there's no valid weblink for a user...?
        // Maybe an alert popping up
        
        if let url = NSURL(string: StudentModel.sharedInstance.students[indexPath.row].mediaURL) {
            
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
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
                
                self.tableView.reloadData()
                
            } else {
                
                // error
                
            }
            
        }
        
    }
    



}
