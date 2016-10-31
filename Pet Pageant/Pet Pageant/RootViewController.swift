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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
