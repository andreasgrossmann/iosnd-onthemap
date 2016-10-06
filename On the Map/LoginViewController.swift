//
//  LoginViewController.swift
//  On the Map
//
//  Created by Andreas on 25/09/2016.
//  Copyright © 2016 Andreas. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    var userKey: String = ""

    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: AnyObject) {
        
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            // try log the user in
            getSessionId()
        }
        
        
    }
    
    
    
    private func getSessionId() {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let dataLength = data?.count
            let r = 5...Int(dataLength!)
            let newData = data?.subdata(in: Range(r)) /* subset response data! */
            
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue))
            
            let parsedResult = (try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            
            print(parsedResult)
            
            if let userKey = (parsedResult["account"] as? [String: Any])?["key"] as? String {
                print(userKey)
                
                self.getUserData(userKey: userKey)
                
            } else {
                
            }
        }
        task.resume()
        
        
    }
    
    
    
    private func getUserData(userKey: String) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/\(userKey)")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let dataLength = data?.count
            let r = 5...Int(dataLength!)
            let newData = data?.subdata(in: Range(r)) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue))
        }
        task.resume()
        
        
    }
    

}

