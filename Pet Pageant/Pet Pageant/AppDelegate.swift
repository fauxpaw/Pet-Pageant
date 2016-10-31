//
//  AppDelegate.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

//TODO: Find suitable themecolor
let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window?.tintColor = themeColor
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "petPageant"
            ParseMutableClientConfiguration.clientKey = "myMasterKey"
            ParseMutableClientConfiguration.server = "https://pet-pageant.herokuapp.com/parse"
        })
        
        Parse.initialize(with: parseConfiguration)
        return true
    }
    
}

