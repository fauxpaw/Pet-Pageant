//
//  UploadImageViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/28/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: OUTLETS
    @IBOutlet weak var imagView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()

    }
    
    func setup(){
        imagView.userInteractionEnabled = true
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadImageViewController.imageTapped(_:)))
        imagView.addGestureRecognizer(tapRecognizer)
        
    }
    
    //MARK: ACTIONS
    
    func imageTapped(sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backButtonSelected(sender: UIBarButtonItem) {
        
        print("back button pressed")
       self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func uploadButtonSelected(sender: UIBarButtonItem) {
        
        print("upload button pressed")
        if imagView.image == nil {
            let alertController = UIAlertController(title: "Image missing", message: "Please tap the image field to select a photo before pressing the upload button.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        else {
            
            let pet = Pet(owner: PFUser.currentUser()!)
            print(PFUser.currentUser())
            pet.saveInBackgroundWithBlock({ (success, error) in
                
                if error == nil {
                    
                    let imageData = UIImagePNGRepresentation(self.imagView.image!)
                    let parseImageFile = PFFile(name: "pet_image.png", data: imageData!)
                    pet["imageFile"] = parseImageFile
                    pet.saveInBackgroundWithBlock({ (success, error) in
                        
                        if success {
                            print("Image successfully saved")
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                        else if let error = error {
                            
                            print("Image not saved. ERROR: \(error.localizedDescription)")
                            let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    })
                }
                else if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
