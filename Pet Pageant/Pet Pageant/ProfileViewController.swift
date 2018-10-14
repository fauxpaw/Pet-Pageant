//
//  ProfileViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UICollectionViewController {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var colView: UICollectionView!
    fileprivate let reuseIdentifier = "PetPhotoCell"
    fileprivate let reuseAddPhoto = "AddPhotoCell"
    fileprivate let reuseMaxPhoto = "AtCapacity"
    fileprivate let photoWidth = (gScreenSize.width - 40) / 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 50, right: 10)
    
    let recordManager = RecordManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "PetCell", bundle: nil), forCellWithReuseIdentifier: "PetCell")
    }
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = PFUser.current() else {return}
        self.recordManager.fetchUsersPetsForProfile(user: user) { (success) in
            if success == true {
                print("users records fetch success")
                self.loadingSpinner.stopAnimating()
                self.colView.reloadData()
            }
        }
    }
    
    //MARK: COLLECTION VIEWCONTROLLER DELEGATE
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recordManager.records.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < self.recordManager.records.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetCell
            cell.petRecord = self.recordManager.records[indexPath.row]
            cell.fetchImageForRecord { (success) in
                // remove spinner on the image view
            }
            cell.setupView()
            return cell
        } else if indexPath.row == self.recordManager.records.count && self.recordManager.records.count >= gPhotoUploadLimit {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseMaxPhoto, for: indexPath) as UICollectionViewCell
            cell.layer.cornerRadius = gCornerRadius
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseAddPhoto, for: indexPath) as UICollectionViewCell
            cell.layer.cornerRadius = gCornerRadius
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.recordManager.records.count && self.recordManager.records.count < gPhotoUploadLimit {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier :"uploadPhotoVC") as! UploadImageViewController
            self.present(destinationVC, animated: true, completion: nil)
        }
        else if indexPath.row < self.recordManager.records.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier :"photoDetails") as! PhotoDetailViewController
            
            guard let petCell = collectionView.cellForItem(at: indexPath) as? PetCell else {
                print("could not find cell at this indexpath")
                return
            }
            guard let record = petCell.petRecord else {
                print("no record attached to this petcell")
                return
            }
            if let img = petCell.imageView.image {
                destinationVC.petImg = img
            }
            destinationVC.pet = record
            self.present(destinationVC, animated: true)
        } else if indexPath.row == self.recordManager.records.count && self.recordManager.records.count == gPhotoUploadLimit {
            
            let alertVC = UIAlertController(title: "Pet Pageant", message: "You are at the upload limit. You may delete a photo from your collection by tapping on it and selecting 'delete.'", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       return CGSize(width: photoWidth, height: photoWidth + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
}
