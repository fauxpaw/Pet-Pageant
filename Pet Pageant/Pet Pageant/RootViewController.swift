//
//  RootViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 10/22/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = gThemeColor
        self.tabBar.barTintColor = gThemeColor
        self.tabBar.tintColor = gBackGroundColor
        self.tabBar.unselectedItemTintColor = UIColor.white
    }
}
