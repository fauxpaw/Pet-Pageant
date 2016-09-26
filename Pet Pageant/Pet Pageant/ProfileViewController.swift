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

class ProfileViewController: UICollectionViewController{

    private let reuseIdentifier = "PetPhotoCell"
    private let reuseAddPhoto = "AddPhotoCell"
    private let photoWidth = (screenSize.width - 40) / 2
    private let sectionInsets = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    
    //TODO: REPLACE WITH DATA SOURCE
    var allImages = [UIImage]()
    var allPets = [Pet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerNib(UINib(nibName: "PetCell", bundle: nil), forCellWithReuseIdentifier: "PetCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.GETUsersPets()
    }
    
    func GETUsersPets() {
        
        self.allPets.removeAll()
        self.allImages.removeAll()
        guard let owner = PFUser.currentUser() else {return}
        let query = PFQuery(className: "Pet")
        query.whereKey("owner", equalTo: owner)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            else {
                let petObjects = objects as! [Pet]
                for object in petObjects {
                    let imageData = object["imageFile"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({ (data: NSData?, error) in
                        if let error = error {
                            print("ERROR fetching image: \(error.localizedDescription) ")
                        }
                        else {
                            if let data = data {
                                guard let image = UIImage(data: data) else {return}
                                self.allImages.append(image)
                                self.allPets.append(object)
                                self.collectionView?.reloadData()
                            }
                        }
                    })
                    
                }
                self.collectionView?.reloadData()
            }
        }
        
    }
    
    //MARK: CollectionViewControllerDelegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allImages.count + 1)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row < allImages.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PetCell", forIndexPath: indexPath) as! PetCell
//            let pic = cell.viewWithTag(2) as! UIImageView
//            pic.image = allImages[indexPath.row]
            cell.imageView.image = allImages[indexPath.row]
            cell.votesLabel.text = "Votes: \(allPets[indexPath.row].votes)"
            cell.viewLabel.text = "Views: \(allPets[indexPath.row].viewed)"
            cell.reportsLabel.text = "Reports: \(allPets[indexPath.row].reports)"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseAddPhoto, forIndexPath: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //reminder - the indexPath.row is 0 based index
        print("You clicked on photo number \(indexPath.row)")
        print("This pics votes: \(allPets[indexPath.row].votes)")
        print("This pics viewed: \(allPets[indexPath.row].viewed)")

        if indexPath.row == allImages.count {
            guard let topVC = UIApplication.sharedApplication().keyWindow?.rootViewController else {return}
           topVC.performSegueWithIdentifier("uploadPhoto", sender: self)
            
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
       return CGSize(width: photoWidth, height: photoWidth + 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
}
