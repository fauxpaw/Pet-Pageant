//
//  UploadImageViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/28/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse
import Photos

enum AttachmentType: String{
    case camera, video, photoLibrary
}

struct Constants {
    static let actionFileTypeHeading = "Add a File"
    static let actionFileTypeDescription = "Choose a filetype to add..."
    static let camera = "Camera"
    static let photoLibrary = "Photo Library"
    static let video = "Video"
    static let file = "File"
    static let alertForPhotoLibraryMessage = "Pet Pageant does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    static let alertForCameraAccessMessage = "Pet Pageant does not have access to your camera. To enable access, tap settings and turn on Camera."
    static let alertForVideoLibraryMessage = "Pet Pageant does not have access to your video. To enable access, tap settings and turn on Video Library Access."
    static let settingsBtnTitle = "Settings"
    static let cancelBtnTitle = "Cancel"
    
}

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
        self.modifyImage()
        self.modifyUploadSpinner()
        self.setupTapGesture()
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
    
    fileprivate func disableActions () {
        self.imagView.isUserInteractionEnabled = false
        self.navBar.isUserInteractionEnabled = false
    }
    
    fileprivate func enableActions () {
        self.imagView.isUserInteractionEnabled = true
        self.navBar.isUserInteractionEnabled = true
    }
    
    //MARK: - IMAGE PICKERCONTROLLER DELEGATE
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkPhotoStatus(completion: @escaping (Bool)->()) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            completion(true)
        }
        else {
            PHPhotoLibrary.requestAuthorization { (action) in
                completion(action == PHAuthorizationStatus.authorized)
            }
        }
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
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
        
        self.checkPhotoStatus { (success) in
            if success == true {
                self.presentImagePicker()
            } else {
                self.addAlertForSettings(AttachmentType.photoLibrary)
            }
        }
        
    }
    
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        self.present(cameraUnavailableAlertController , animated: true, completion: nil)
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
            
            //capture the photo first!
            
            //then attach to the pet record and save
            
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
