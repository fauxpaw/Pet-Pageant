//
//  ProfileViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//
let screenSize: CGRect = UIScreen.mainScreen().bounds

import UIKit
import Parse
import ParseUI

class ProfileViewController: UICollectionViewController{

    private let reuseIdentifier = "PetPhotoCell"
    private let reuseAddPhoto = "AddPhotoCell"
    private let photoWidth = (screenSize.width - 40) / 2
    private let sectionInsets = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    
    
    //TODO: REPLACE WITH DATA SOURCE
    var allPets = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.GETUsersPets()
    }
    
    func GETUsersPets() {
        
        self.allPets.removeAll()
        guard let owner = PFUser.currentUser() else {return}
        let query = PFQuery(className: "Pet")
        query.whereKey("owner", equalTo: owner)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            else {
                print("pet objects...")
                let petObjects = objects as! [Pet]
                print(petObjects)
                for object in petObjects {
                    let imageData = object["imageFile"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({ (data: NSData?, error) in
                        if let error = error {
                            print("ERROR fetching image: \(error.localizedDescription) ")
                        }
                        else {
                            print("fetching images...")
                            if let data = data {
                                guard let image = UIImage(data: data) else {return}
                                self.allPets.append(image)
                                self.collectionView?.reloadData()
                            }
                        }
                    })
                    
                }
            }
        }
        
    }
    
    //MARK: CollectionViewControllerDelegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allPets.count + 1)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row < allPets.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
            let pic = cell.viewWithTag(2) as! UIImageView
            pic.image = allPets[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseAddPhoto, forIndexPath: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //reminder - the indexPath.row is 0 based index
        print("You clicked on photo number \(indexPath.row)")
        
        if indexPath.row == allPets.count {
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
