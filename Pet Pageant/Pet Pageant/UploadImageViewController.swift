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
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: CLASS METHODS
    
    func setup(){
        imagView.isUserInteractionEnabled = true
        self.setupTapGesture()
    }
    
    //MARK: IMAGE PICKERCONTROLLER DELEGATE
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: GESTURES
    
    func setupTapGesture() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadImageViewController.imageTapped(_:)))
        imagView.addGestureRecognizer(tapRecognizer)
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: ACTIONS
    
    @IBAction func backButtonSelected(_ sender: UIBarButtonItem) {
        
        print("back button pressed")
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonSelected(_ sender: UIBarButtonItem) {
        
        print("upload button pressed")
        if imagView.image == nil {
            let alertController = UIAlertController(title: "Image missing", message: "Please tap the image field to select a photo before pressing the upload button.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else {
            
            let pet = Pet(owner: PFUser.current()!)
            pet.saveInBackground(block: { (success, error) in
                
                if error == nil {
                    
                    let imageData = UIImagePNGRepresentation(self.imagView.image!)
                    let parseImageFile = PFFile(name: "pet_image.png", data: imageData!)
                    pet["imageFile"] = parseImageFile
                    pet.saveInBackground(block: { (success, error) in
                        
                        if success {
                            print("Image successfully saved")
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        else if let error = error {
                            
                            print("Image not saved. ERROR: \(error.localizedDescription)")
                            let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
                else if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
}
