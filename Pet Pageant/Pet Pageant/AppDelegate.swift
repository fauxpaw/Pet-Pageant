//
//  AppDelegate.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "pp"
            ParseMutableClientConfiguration.clientKey = "myMasterKey"
            ParseMutableClientConfiguration.server = "http://pet-pageant.herokuapp.com/parse"
        })
        
        Parse.initializeWithConfiguration(parseConfiguration)
        return true
    }
    
}

