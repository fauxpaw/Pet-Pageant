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
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imagView: UIImageView!
    
    fileprivate let defaultImage = UIImage(named: "selectPhoto.png")
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: CLASS METHODS
    
    internal override func setup(){
        super.setup()
        self.modifyNavBar()
        self.modifyImage()
        self.modifyUploadSpinner()
        self.setupTapGesture()
    }
    
    fileprivate func modifyNavBar () {
        self.navigationController?.navigationBar.tintColor = gTextColor
        
        if (navigationController != nil) {
            print("we has a item")
        }
        
    }
    
    internal override func modifyImage() {
        self.imagView.image = defaultImage
    }
    
    fileprivate func modifyUploadSpinner () {
        spinner.center = self.imagView.center
        spinner.color = gThemeColor
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
    }
    
    fileprivate func showUploadSpinner () {
        spinner.startAnimating()
        
    }
    
    fileprivate func hideUploadSpinner () {
        spinner.stopAnimating()
    }
    
    //The two methods below are temporary bandaids to ensure that the user cannot spam buttons or change photos while uploading is taking place. This will cause the app to crash and the upload will not complete correctly.
    
    fileprivate func disableActions () {
        self.imagView.isUserInteractionEnabled = false
        self.navBar.isUserInteractionEnabled = false
    }
    
    fileprivate func enableActions () {
        self.imagView.isUserInteractionEnabled = true
        self.navBar.isUserInteractionEnabled = true
    }
    
    //MARK: IMAGE PICKERCONTROLLER DELEGATE
    
    //As of iOS 10.x this will prompt a faulty error message of "Creating an image format with an unknown type is an error" - may safely disregard
    
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
            self.disableActions()
            self.showUploadSpinner()
            let pet = Pet(owner: PFUser.current()!)
            if let img: UIImage = imagView.image {
                weak var weakSelf = self
                pet.saveInBackground(block: { (success, error) in
                    guard let strongSelf = weakSelf else {return}

                    if error == nil {
                        
                        let imageData = UIImagePNGRepresentation(img)
                        let parseImageFile = PFFile(name: "pet_image.png", data: imageData!)
                        pet["imageFile"] = parseImageFile
                        pet.saveInBackground(block: { (success, error) in
                            
                            if success {
                                strongSelf.hideUploadSpinner()
                                print("Image successfully saved")
                                strongSelf.enableActions()
                                strongSelf.dismiss(animated: true, completion: nil)
                                
                            }
                            else if let error = error {
                                strongSelf.hideUploadSpinner()
                                print("Image not saved. ERROR: \(error.localizedDescription)")
                                strongSelf.enableActions()
                                let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                strongSelf.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                    else if let error = error {
                        strongSelf.enableActions()
                        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        strongSelf.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
