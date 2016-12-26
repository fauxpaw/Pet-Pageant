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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.login()
    }
    
    func setup() {
        logoutButton.layer.cornerRadius = 4
    }
    
    //MARK: LOGIN SETUP
    
    func login(){
        
        if (PFUser.current() == nil) {
            let loginViewController: PFLogInViewController = PFLogInViewController()
            loginViewController.fields = [PFLogInFields.usernameAndPassword, PFLogInFields.logInButton, PFLogInFields.signUpButton, PFLogInFields.passwordForgotten, PFLogInFields.dismissButton, PFLogInFields.facebook, PFLogInFields.twitter]
            
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
            self.present(loginViewController, animated: true, completion: nil)
            
        } else {
            print("User is logged in")
        }
    }
    
    
    //MARK: PARSE LOGIN DELEGATE

    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @nonobjc func log(_ logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {

        let alertController = UIAlertController(title: "Pet Pageant", message: "Login failed due to error \(error)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logInViewControllerDidCancelLog(in logInController: PFLogInViewController) {
    }
    
    //MARK: PARSE SIGN-UP
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        
        self.dismiss(animated: true, completion: nil)
        self.login()
        let alertController = UIAlertController(title: "Pet Pageant", message: "You have successfully signed up and are now logged in. Have fun!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.login()
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @nonobjc func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: "Signup failed due to \(error.localizedDescription).", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func signUpViewControllerDidCancelSignUp(_ signUpController: PFSignUpViewController) {
    }
    
    //MARK: ACTIONS
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        PFUser.logOut()
       
        let alertController = UIAlertController(title: "Pet Pageant", message: "You have successfully logged out.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.login()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

