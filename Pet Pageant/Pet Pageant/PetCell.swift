//
//  PetCell.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/15/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class PetCell: UICollectionViewCell {
    
    //MARK: PROPERTIES
    
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var reportsLabel: UILabel!
    
    var petRecord : Pet?
    
    func setupView() {
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = gCornerRadius
            self.layer.cornerRadius = gCornerRadius
            self.layer.borderWidth = gBorderWidthDefault
            self.layer.borderColor = gThemeColor.cgColor
            self.labelBackgroundView.layer.cornerRadius = gCornerRadius
            self.labelBackgroundView.layer.borderWidth = gBorderWidthDefault
            self.labelBackgroundView.layer.borderColor = gThemeColor.cgColor
            self.labelBackgroundView.backgroundColor = gBackGroundColor
            self.backgroundColor = gThemeColor
        }
    }
    
    func fetchImageForRecord(completion: @escaping (Bool)->()){
        guard let petRecord = self.petRecord else {
            print("No pet record on this voteview")
            completion(false)
            return
        }
        
        guard let imageData = petRecord["imageFile"] as? PFFile else {
            print("PFFile badness for key 'imageFile'")
            API.deleteRecord(record: petRecord)
            completion(false)
            return
        }
        
        imageData.getDataInBackground(block: { (data: Data?, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let stuff = data else {
                print("data param came back nil")
                completion(false)
                return
            }
            guard let img = UIImage(data: stuff) else {
                print("failed to init UIImage from data ")
                completion(false)
                return
            }
            self.imageView.image = img
            completion(true)
        })
    }
}
