//
//  PhotoDetailViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class PhotoDetailViewController: CustomBaseViewContollerViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var shownLabel: UILabel!
    @IBOutlet weak var reportsLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
   
    var pet: Pet?
    var image: UIImage?
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: CLASS METHODS
    
    internal override func setup() {
        super.setup()
        self.modifyImage()
        self.updateLabels()
        self.modifyLabels()
        self.modifyNavbar()
        self.setupTap()
        self.enableActions()
    }
    
    internal override func modifyImage() {
        super.modifyImage()
        self.imageView.image = image
    }
    
    private func updateLabels () {
        if let pet = pet {
            votesLabel.text = "Number of votes: \(pet.votes)"
            shownLabel.text = "Number of times viewed: \(pet.viewed)"
            reportsLabel.text = "Number of reports: \(pet.reports)"
            self.ownerLabel.text = ""
        } else {
            print("pet not found")
        }
    }
    
    private func modifyLabels () {
        let labels = [ownerLabel, votesLabel, shownLabel, reportsLabel]
        for label in labels {
            label?.textColor = gThemeColor
        }
    }
    
    private func modifyNavbar(){
        self.navigationController?.navigationBar.barTintColor = gThemeColor
    }
    
    //The two methods below are temporary bandaids to ensure that the user cannot spam buttons or change photos while uploading is taking place. This will cause the app to crash and the upload will not complete correctly.
    
    fileprivate func disableActions () {
        self.navBar.isUserInteractionEnabled = false
    }
    
    fileprivate func enableActions () {
        self.navBar.isUserInteractionEnabled = true
    }
    
    //MARK: GESTURES
    fileprivate func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailViewController.imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    func imageTapped(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: ACTIONS
    
    @IBAction func deleteButtonSelected(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Pet Pageant", message: "Are you sure you want to delete this record and all its coresponding data?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            self.disableActions()
            //API call to delete record
            guard let record = self.pet  else { return }
            record.deleteInBackground { (success, error) in

                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "Could not delete item due to \(error.localizedDescription)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
