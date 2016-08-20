//
//  CustomLoginViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/18/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class CustomLoginViewController: UIViewController {

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
    
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        if (username!.utf16.count < 4 || password!.utf16.count < 5) {
            
            let alertController = UIAlertController(title: "Invalid", message: "Username must be greater than 4 and password must be greater than 5", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                print("alert presented")
            }
            
        } else {
            self.spinner.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user, error) -> Void in
                
                self.spinner.stopAnimating()
                
                if ((user) != nil){
                    
                    let alertController = UIAlertController(title: "Success!", message: "You have logged in", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        print("alert presented")
                    }

                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        print("alert presented")
                    }
                }
            })
        }
        
    }
   
    @IBAction func signupButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("signup", sender: self)
        
    }

}
