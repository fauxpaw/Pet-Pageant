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

    fileprivate let reuseIdentifier = "PetPhotoCell"
    fileprivate let reuseAddPhoto = "AddPhotoCell"
    fileprivate let photoWidth = (screenSize.width - 40) / 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    
    //TODO: REPLACE WITH DATA SOURCE
    var allImages = [UIImage]()
    var allPets = [Pet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "PetCell", bundle: nil), forCellWithReuseIdentifier: "PetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.GETUsersPets()
    }
    
    func GETUsersPets() {
        
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
                for object in petObjects {
                    let imageData = object["imageFile"] as! PFFile
                    imageData.getDataInBackground(block: { (data: Data?, error) in
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allImages.count + 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath as NSIndexPath).row < allImages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetCell
//            let pic = cell.viewWithTag(2) as! UIImageView
//            pic.image = allImages[indexPath.row]
            cell.imageView.image = allImages[(indexPath as NSIndexPath).row]
            cell.votesLabel.text = "Votes: \(allPets[(indexPath as NSIndexPath).row].votes)"
            cell.viewLabel.text = "Views: \(allPets[(indexPath as NSIndexPath).row].viewed)"
            cell.reportsLabel.text = "Reports: \(allPets[(indexPath as NSIndexPath).row].reports)"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseAddPhoto, for: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //reminder - the indexPath.row is 0 based index
        

        if (indexPath as NSIndexPath).row == allImages.count {
            guard let topVC = UIApplication.shared.keyWindow?.rootViewController else { return }
           topVC.performSegue(withIdentifier: "uploadPhoto", sender: self)
        }
        else if (indexPath as NSIndexPath).row < allImages.count {
            print("You clicked on photo number \((indexPath as NSIndexPath).row)")
            print("This pics votes: \(allPets[(indexPath as NSIndexPath).row].votes)")
            print("This pics viewed: \(allPets[(indexPath as NSIndexPath).row].viewed)")
             let topVC = UIApplication.shared.keyWindow?.rootViewController as! RootViewController
            topVC.pet = allPets[(indexPath as NSIndexPath).row]
            topVC.votes = allPets[(indexPath as NSIndexPath).row].votes
            topVC.shown = allPets[(indexPath as NSIndexPath).row].viewed
            topVC.reports = allPets[(indexPath as NSIndexPath).row].reports
            topVC.photo = allImages[(indexPath as NSIndexPath).row]

            topVC.performSegue(withIdentifier: "photoDetails", sender: self)
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       return CGSize(width: photoWidth, height: photoWidth + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
}
