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
    
    @NSManaged var owner: PFUser
    @NSManaged var votes: Int
    @NSManaged var viewed: Int
    @NSManaged var reports: Int
    @NSManaged var imageFile: PFFile
    
    static func parseClassName() -> String {
        return "Pet"
    }
    
    init(owner: PFUser) {
        super.init()
        self.owner = owner
        self.votes = 0
        self.viewed = 0
        self.reports = 0
        
    }
    
    override init() {
        super.init()
    }
    
}
