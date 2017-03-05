//
//  UploadImageViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/28/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class UploadImageViewController: CustomBaseViewContollerViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: OUTLETS
    
    @IBOutlet weak var imagView: UIImageView!
    fileprivate var defaultImage = UIImage(named: "selectPhoto.png")
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: CLASS METHODS
    
    internal override func setup(){
        super.setup()
        self.modifyImage()
        self.setupTapGesture()
        self.modifyNavBar()
    }
    
    fileprivate func modifyNavBar () {
        self.navigationController?.navigationBar.tintColor = gThemeColor
    }
    
    internal override func modifyImage() {
        self.imagView.image = defaultImage
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
        if imagView.image != self.defaultImage {
            imagView.image = self.defaultImage
            return
        }
        
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
        if imagView.image == nil || imagView.image == defaultImage {
            let alertController = UIAlertController(title: "Image Missing", message: "Please tap the image field to select a photo before pressing the upload button.", preferredStyle: .alert)
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
