//
//  CustomSignupViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/18/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class CustomSignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.spinner)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        
        if (username!.utf16.count < 4 || password!.utf16.count < 5) {
            
            let alertController = UIAlertController(title: "Invalid", message: "Username must be greater than 4 and password must be greater than 5", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                print("alert presented")
            }
            
        } else if (email?.utf16.count < 8){
            
            let alertController = UIAlertController(title: "Invalid email", message: "email must be greater than 8 characters", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                print("alert presented")
            }
            
        } else {
            
            self.spinner.startAnimating()
            let newUser = PFUser()
            newUser.password = username
            newUser.password = password
            newUser.email = email
            
            newUser.signUpInBackgroundWithBlock({ (succeeded, error) in
                
                if ((error) != nil) {
                    
                    let alertController = UIAlertController(title: "ERROR", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        print("alert presented")
                    }
                } else {
                    
                    let alertController = UIAlertController(title: "Success", message: "Sign up completed", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        print("alert presented")
                    }
                    
                }
                
            })
            
        }
        
    }
    
    
}
