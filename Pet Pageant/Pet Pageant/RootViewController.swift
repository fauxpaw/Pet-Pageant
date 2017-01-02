//
//  RootViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 10/22/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    var pet: Pet?
    var votes: Int?
    var shown: Int?
    var reports: Int?
    var photo: UIImage?
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
