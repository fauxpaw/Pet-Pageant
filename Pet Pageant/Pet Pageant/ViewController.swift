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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    func pictureTest () {
//        
//        guard let picture = UIImage(named: "anna.png") else {print("picture not converted..."); return }
//        let pictureData = UIImagePNGRepresentation(picture)
//        let file = PFFile(name: "image", data: pictureData!)
//        file?.saveInBackgroundWithBlock({ (success, error) in
//            if success {
//                
//                let currentUser = PFUser.currentUser()
//                let nova = Pet(image: file!, owner: currentUser!)
//    
//                nova.saveInBackgroundWithBlock({ (success, error) in
//                    if success {
//                        print("nova saved success!")
//                    }
//                    else if let error = error {
//                        print("ERROR: \(error.localizedDescription)")
//                    }
//                    
//                })
//            }
//            else if let error = error{
//                print("ERROR: \(error.localizedDescription)")
//            }
//        })
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.login()
    }
    
    //MARK: LOGIN SETUP
    
    func login(){
        
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            let loginViewController: PFLogInViewController = PFLogInViewController()
            loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton, PFLogInFields.Facebook, PFLogInFields.Twitter]
            
            //TODO: SKIN - SPLASH SCREEN
            let loginLogoTitle = UILabel()
            loginLogoTitle.text = "Pet Pageant <placeholder>"
            loginViewController.logInView?.logo = loginLogoTitle
            loginViewController.delegate = self
            loginViewController.signUpController?.delegate = self
            
            //TODO: SKIN - SPLASH SCREEN
            let signupLogoTitle = UILabel()
            signupLogoTitle.text = "Pet Pageant <placeholder>"
            loginViewController.signUpController?.signUpView?.logo = signupLogoTitle
            self.presentViewController(loginViewController, animated: true, completion: nil)
            
        } else {
//            self.pictureTest()
            print("user signed in?")

        }
    }
    
    
    //MARK: PARSE LOGIN DELEGATE

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {

        print("failed to login. ERROR: \(error)")
        let alertController = UIAlertController(title: "Pet Pageant", message: "Login failed due to error \(error)", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
    }
    
    //MARK: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.login()
        let alertController = UIAlertController(title: "Pet Pageant", message: "You have successfully signed up and are now logged in.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            self.login()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        //TODO: ALERT
        print("failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
    }
    
    //MARK: ACTIONS
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        PFUser.logOut()
       
        let alertController = UIAlertController(title: "Pet Pageant", message: "You have successfully logged out.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            self.login()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}

