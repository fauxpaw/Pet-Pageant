//
//  ViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.


import UIKit
import Parse
import ParseUI

class ViewController: CustomBaseViewContollerViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {
    
    var loginVC = LoginViewController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoutButton.layer.cornerRadius = gCornerRadiusButton
        self.setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.login()
    }
    
    override func modifyImage() {
        // remove base behavior for image
    }
    
    override func modifyButtons() {
        //
    }
    
    //MARK: CLASS METHODS
    
    fileprivate func login(){
        
        if (PFUser.current() == nil) {
            loginVC.fields = [PFLogInFields.usernameAndPassword, PFLogInFields.logInButton, PFLogInFields.signUpButton, PFLogInFields.dismissButton]
          //TODO: PFLogInFields.passwordForgotten
            loginVC.delegate = self
            loginVC.signUpController?.delegate = self
            
            self.present(loginVC, animated: true, completion: nil)
            
        } else {
            guard let user = PFUser.current() else {return}
            if let name = user.username {
                print("\(name) is logged in")
            }
            if let pw = user.password {
                print("user password = \(pw)")
            }
            if let email = user.email {
                print("\(email)")
            }
        }
    }
    
    
    //MARK: PARSE LOGIN DELEGATE

    public func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    public func log(_ logInController: PFLogInViewController, didFailToLogInWithError error: Error?) {
        
        if let error = error {
            let alertController = UIAlertController(title: "Pet Pageant", message: "Login failed - \(error.localizedDescription)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.loginVC.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func logInViewControllerDidCancelLog(in logInController: PFLogInViewController) {
        
    }
    
    //MARK: PARSE SIGN-UP
    
    public func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        let alertController = UIAlertController(title: "Pet Pageant", message: "You have successfully signed up and are now logged in. Have fun!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.login()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: Error?) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: "Signup failed due to \(error.localizedDescription).", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    public func signUpViewControllerDidCancelSignUp(_ signUpController: PFSignUpViewController) {
        self.dismiss(animated: true, completion: nil)
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

