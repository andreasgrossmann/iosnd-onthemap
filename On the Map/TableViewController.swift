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
        
        if let url = NSURL(string: StudentModel.sharedInstance.students[indexPath.row].mediaURL) {
            
            print(url) // Note: This won't open URLs that are missing the http(s):// prefix
            
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }
        
        
    }



}
