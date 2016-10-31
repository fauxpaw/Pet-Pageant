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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    func pictureTest () {
//        
//        if imageView.image == nil {
//            print("image view has no image... assign before we can save to parse")
//            let alertController = UIAlertController(title: "Error:", message: "You have not selected an image. Please tap the image field to select a photo to upload.", preferredStyle: .Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
//        else {
//            
//            let imageTest = PFObject(className: "Anna")
//            imageTest["name"] = "Anna Kendrick"
//            imageTest["title"] = "Your Goddess"
//            imageTest["user"] = PFUser.currentUser()
//            imageTest.saveInBackgroundWithBlock({ (success, error) in
//                
//                if error == nil {
//                    
//                    let imageData = UIImagePNGRepresentation(self.imageView.image!)
//                    let parseImageFile = PFFile(name: "the_hotness.png", data: imageData!)
//                    imageTest["imageFile"] = parseImageFile
//                    imageTest.saveInBackgroundWithBlock({ (success, error) in
//                        
//                        if success {
//                            print("Image successfully saved")
//                        }
//                        else if let error = error {
//                            
//                            print("Image not saved. ERROR: \(error.localizedDescription)")
//                        }
//                        
//                    })
//                }
//                
//            })
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.login()
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
//            self.pictureTest()

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
    
    //MARK: Parse Signup
    
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
    
    //MARK: TESTS
    
    @IBAction func queryButtonPressed(_ sender: UIButton) {
        
      let query = PFQuery(className: "Pet")
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                let imageObjects = objects as! [Pet]
                for (_, object) in imageObjects.enumerated() {
                    let thumbnail = object["imageFile"] as! PFFile
                    thumbnail.getDataInBackground(block: { (imageData: Data?, error) in
                        if error == nil {
                            if let image = UIImage(data: imageData!) {
                                self.imageView.image = image
                            }
                            
                        }
                        else {
                            print("error getting the data")
                            let alertController = UIAlertController(title: "ERROR:", message: "Could not retrieve image due to error \(error?.localizedDescription)", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            }
            else {
                print("Error: \(error?.localizedDescription)")
                let alertController = UIAlertController(title: "Error!", message: "Could not retrieve desired data due to erorr \(error?.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

