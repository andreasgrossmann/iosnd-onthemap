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
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        

        
        setUIEnabled(enabled: false)
        
        /* Check for username */
        guard emailTextField.text != "" else {
            displayAlert(message: "Please enter your username.")
            setUIEnabled(enabled: true)
            return
        }
        
        /* Check for password */
        guard passwordTextField.text != "" else {
            displayAlert(message: "Please enter your password.")
            setUIEnabled(enabled: true)
            return
        }
        

        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        /* Try to log the user in */
        UdacityClient.sharedInstance().getSessionId(username: emailTextField.text!, password: passwordTextField.text!) { (userKey, errorString) in
            
            
            performUIUpdatesOnMain {
                if let userKey = userKey {
                    
                    self.getStudentWithUserKey(userKey: userKey)
                
                } else {
                    
                    /* Enable the UI again and show the error */
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.setUIEnabled(enabled: true)
                    self.displayAlert(message: errorString!)
                        
                }
            }
                
        }
        
        
        
    }
    
    
    
    
    @IBAction func signUpPressed(_ sender: AnyObject) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    
    
    
    
    
    
    // GET Student Data
    
    func getStudentWithUserKey(userKey: String) {
        UdacityClient.sharedInstance().studentWithUserKey(userKey: userKey) { (success, error) in
            performUIUpdatesOnMain {
                if success! {
                    self.completeLogin()
                } else {
                    // error
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: Login
    
    private func completeLogin() {
//        debugTextLabel.text = ""
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    
    

    

}







// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    func setUIEnabled(enabled: Bool) {
        loginButton.isEnabled = enabled
        
        // Set button title
        if enabled {
            loginButton.setTitle("LOGIN", for: UIControlState.normal)
        } else {
            loginButton.setTitle("We're logging you in...", for: UIControlState.disabled)
        }
    }
    
//    func displayError(errorString: String?) {
//        if let errorString = errorString {
//            debugTextLabel.text = errorString
//        }
//    }
    

}

