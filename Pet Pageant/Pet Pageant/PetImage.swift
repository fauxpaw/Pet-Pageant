//
//  PetImage.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/26/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class Pet: PFObject, PFSubclassing {
    
    @NSManaged var image: PFFile
    @NSManaged var owner: PFUser
    @NSManaged var votes: Int
    @NSManaged var viewed: Int
    @NSManaged var reports: Int
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Pet"
    }
    
    init(image: PFFile, owner: PFUser) {
        super.init()
        
        self.image = image
        self.owner = owner
        self.votes = 0
        self.viewed = 0
        self.reports = 0
        
    }
    
}
