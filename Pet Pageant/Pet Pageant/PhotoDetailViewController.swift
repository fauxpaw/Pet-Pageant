//
//  PhotoDetailViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var shownLabel: UILabel!
    @IBOutlet weak var reportsLabel: UILabel!
    
    var pet: Pet?
    var image: UIImage?
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: CLASS METHODS
    
    func setup() {
        
        if let pet = pet {
            votesLabel.text = "Number of votes: \(pet.votes)"
            shownLabel.text = "Number of times viewed: \(pet.viewed)"
            reportsLabel.text = "Number of reports: \(pet.reports)"
        } else {
            print("pet not found")
        }
        
        
        imageView.image = image
    }
    
    //MARK: ACTIONS
    
    @IBAction func deleteButtonSelected(_ sender: Any) {
        
        guard let record = pet  else { return }
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
        
    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
