//
//  RootViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 10/22/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController, StatusBarBackgroundProtocol {

    var pet: Pet?
    var votes: Int?
    var shown: Int?
    var reports: Int?
    var photo: UIImage?
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        modifyStatusBarBackground(view: self.view)
        self.tabBar.barTintColor = gThemeColor
//        if #available(iOS 10.0, *) {
//            self.tabBar.unselectedItemTintColor = gTextColor
//        } else {
//            // Fallback on earlier versions
//        }
        
        self.tabBar.tintColor = gTextColor

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue called from root")
        if segue.identifier == "photoDetails" {
            print("photo details segue")
            let photoDetailsVC = segue.destination as! PhotoDetailViewController
            photoDetailsVC.pet = self.pet
            photoDetailsVC.image = self.photo
        }
    }
}
