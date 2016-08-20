//
//  ViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse
import ParseUI




class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var loginViewController: PFLogInViewController = PFLogInViewController()
    var signupViewController: PFSignUpViewController = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testObject = PFObject(className: "testObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success, error) in
            
            if (error != nil) {
                print("success")
            }
            else {
                print("ERROR: \(error)")
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            
            self.loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
            
            let loginLogoTitle = UILabel()
            loginLogoTitle.text = "Pet Pageant"
            
            self.loginViewController.logInView?.logo = loginLogoTitle
            
            self.loginViewController.delegate = self
            
            //TODO: make image view for background
            let signupLogoTitle = UILabel()
            signupLogoTitle.text = "Pet Pageant"
            self.signupViewController.signUpView?.logo = signupLogoTitle
            self.signupViewController.delegate = self
            self.loginViewController.signUpController = self.signupViewController
            
        }
        
    }
    
    //MARK: Parselogin
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    
    }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("failed to login")
    }
    
    //MARK: Parse Signup
   
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("failed to signup")
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("user dismissed signup")
    }
    
    //MARK: Actions
    
    @IBAction func simpleAction(sender: AnyObject) {
        self.presentViewController(self.loginViewController, animated: true, completion: nil)
    }
    
   
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("login", sender: self)

    }
    
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
        PFUser.logOut()
    }
   
    
}

