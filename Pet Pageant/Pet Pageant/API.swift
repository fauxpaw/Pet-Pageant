//
//  API.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 6/4/18.
//  Copyright © 2018 Michael Sweeney. All rights reserved.
//

import Foundation
import Parse


struct API {
    
    static func Fetch50Pets(completion: @escaping ([Pet]) -> ()) {
        
        var petArray = [Pet]()
        guard let user = PFUser.current() else {
            print("Could not find user")
            return
        }
        let query = PFQuery(className: "Pet")
        query.order(byAscending: "updatedAt")
        query.whereKey("usersBlocked", notEqualTo: user)
        query.limit = 50
        query.findObjectsInBackground { (objects, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                guard let petObjects = objects as? [Pet] else {
                    print("failed to cast fetched objects into <Pet> type")
                    return}
                petArray = petObjects
                completion(petArray)
            }
        }
    }
    
    static func deleteRecord(record: Pet) {
        record.deleteInBackground { (success, error) in
            
            if let error = error {
                print("Could not delete item due to \(error.localizedDescription)")
            }
            else {
                print("Record Successfully deleted!")
            }
        }
    }
    
    static func fetchTopPets(count: Int, completion: @escaping ([Pet]) -> ()) {
        let query = PFQuery(className: "Pet")
        query.order(byDescending: "votes")
        query.limit = count
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let petObjects = objects as? [Pet] {
                completion(petObjects)
            }
        }
    }
    
    static func fetchUsersPets(user: PFUser, completion: @escaping ([Pet]) -> ()) {
        let query = PFQuery(className: "Pet")
        query.whereKey("owner", equalTo: user)
        query.order(byDescending: "votes")
        query.findObjectsInBackground { (records, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            if let petRecords = records as? [Pet] {
                completion(petRecords)
            }
        }
    }
}
