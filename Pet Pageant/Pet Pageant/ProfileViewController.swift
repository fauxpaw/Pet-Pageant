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

    @IBOutlet var colView: UICollectionView!
    fileprivate let reuseIdentifier = "PetPhotoCell"
    fileprivate let reuseAddPhoto = "AddPhotoCell"
    fileprivate let reuseMaxPhoto = "AtCapacity"
    fileprivate let photoWidth = (gScreenSize.width - 40) / 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    
    
    var retrieved = false
    var allImages = [UIImage]()
    var allPets = [Pet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "PetCell", bundle: nil), forCellWithReuseIdentifier: "PetCell")
    }
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colView.reloadData()
        self.addOverlay()
        self.GETUsersPets()
    }
    
    fileprivate func addOverlay() {
        
        if let exists = self.view.viewWithTag(1) {
            self.view.bringSubview(toFront: exists)
            return
        }
        
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: gScreenSize.width, height: gScreenSize.height))
        overlay.backgroundColor = gBackGroundColor
        overlay.tag = 1
        let spinner = UIActivityIndicatorView()
        spinner.color = gThemeColor
        spinner.startAnimating()
        spinner.center = overlay.center
        overlay.addSubview(spinner)
        self.view.addSubview(overlay)
        self.view.bringSubview(toFront: overlay)
    }
    
    fileprivate func removeOverlay() {
        guard let view = self.view.viewWithTag(1) else { return }
        self.view.sendSubview(toBack: view)
    }
    
    //MARK: BACKEND CALLS
    
    fileprivate func GETUsersPets() {
        
        self.allPets.removeAll()
        self.allImages.removeAll()
        guard let owner = PFUser.current() else {return}
        let query = PFQuery(className: "Pet")
        query.whereKey("owner", equalTo: owner)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            else {
                let petObjects = objects as! [Pet]
                self.colView.isHidden = false
                for object in petObjects {
                    let imageData = object["imageFile"] as! PFFile
                    weak var weakSelf = self
                    imageData.getDataInBackground(block: { (data: Data?, error) in
                        guard let strongSelf = weakSelf else {return}
                        if let error = error {
                            print("ERROR fetching image: \(error.localizedDescription) ")
                        }
                        else {
                            if let data = data {
                                guard let image = UIImage(data: data) else {return}
                                strongSelf.allImages.append(image)
                                strongSelf.allPets.append(object)
                                strongSelf.collectionView?.reloadData()
                            }
                        }
                    })
                }
            }
             self.removeOverlay()
        }
    }
    
    //MARK: COLLECTION VIEWCONTROLLER DELEGATE
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allImages.count + 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath as NSIndexPath).row < allImages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetCell

            cell.imageView.image = allImages[(indexPath as NSIndexPath).row]
            cell.votesLabel.text = "Votes: \(allPets[(indexPath as NSIndexPath).row].votes)"
            cell.viewLabel.text = "Views: \(allPets[(indexPath as NSIndexPath).row].viewed)"
            cell.reportsLabel.text = "Reports: \(allPets[(indexPath as NSIndexPath).row].reports)"
            cell.imageView.layer.cornerRadius = gCornerRadius
            cell.layer.cornerRadius = gCornerRadius
            cell.layer.borderWidth = gBorderWidthDefault
            cell.layer.borderColor = gThemeColor.cgColor
            cell.labelBackgroundView.layer.cornerRadius = gCornerRadius
            cell.labelBackgroundView.layer.borderWidth = gBorderWidthDefault
            cell.labelBackgroundView.layer.borderColor = gThemeColor.cgColor
            cell.labelBackgroundView.backgroundColor = gBackGroundColor
            cell.backgroundColor = gThemeColor
            return cell
        } else if (indexPath as NSIndexPath).row == allImages.count && allImages.count >= gPhotoUploadLimit {
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
        //reminder - the indexPath.row is 0 based index
        
        if (indexPath as NSIndexPath).row == allImages.count && allImages.count < gPhotoUploadLimit {
            guard let topVC = UIApplication.shared.keyWindow?.rootViewController else { return }
           topVC.performSegue(withIdentifier: "uploadPhoto", sender: self)
        }
        else if (indexPath as NSIndexPath).row < allImages.count {
             let topVC = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            topVC.pet = allPets[(indexPath as NSIndexPath).row]
            topVC.votes = allPets[(indexPath as NSIndexPath).row].votes
            topVC.shown = allPets[(indexPath as NSIndexPath).row].viewed
            topVC.reports = allPets[(indexPath as NSIndexPath).row].reports
            topVC.photo = allImages[(indexPath as NSIndexPath).row]

            topVC.performSegue(withIdentifier: "photoDetails", sender: self)
        } else if (indexPath as NSIndexPath).row == allImages.count && allImages.count == gPhotoUploadLimit {
            
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
