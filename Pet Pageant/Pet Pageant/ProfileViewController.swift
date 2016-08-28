//
//  ProfileViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//
let screenSize: CGRect = UIScreen.mainScreen().bounds

import UIKit

class ProfileViewController: UICollectionViewController{

    private let reuseIdentifier = "PetPhotoCell"
    private let reuseAddPhoto = "AddPhotoCell"
    private let photoWidth = (screenSize.width - 40) / 2
    private let sectionInsets = UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10)
    
    //TODO: REPLACE WITH DATA SOURCE
    let allPets = [1,2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseAddPhoto, forIndexPath: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //reminder - the indexPath.row is 0 based index
        print("You clicked on photo number \(indexPath.row)")
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
