//
//  RecordManager.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 6/5/18.
//  Copyright © 2018 Michael Sweeney. All rights reserved.
//

import Foundation
import Parse

class RecordManager {
    
    var records = [Pet]()
    // keep dictionary of record ids in queue
    
    func fetchRecordBatch(completion: @escaping (Bool)->()) {
        API.Fetch50Pets { (pets) in
            self.records = pets
            completion(true)
            return
        }
    }
    
    func getTwoRecords() -> (Pet,Pet)? {
        if self.records.isEmpty{
            print("VOTEQUE EMPTY -> Aborting chooseRecords")
            return nil
        }
        
        let objectIndex1 = Int(arc4random_uniform(UInt32(self.records.count)))
        var objectIndex2 = Int(arc4random_uniform(UInt32(self.records.count)))
        
        while objectIndex1 == objectIndex2 {
            objectIndex2 = Int(arc4random_uniform(UInt32(self.records.count)))
        }
        
        guard let rec1 = self.removeRecordAtIndex(index: objectIndex1) else {return nil}
        if self.isDuplicate(record: rec1, atIndex: max(objectIndex2-1, 0)) {
            return nil
        }
        guard let rec2 = self.removeRecordAtIndex(index: max(objectIndex2-1, 0)) else {return nil}
        if self.isPetOwner(record: rec1)  || self.isPetOwner(record: rec2) {
            print("Owners pet displayed")
        }
        return (rec1,rec2)
    }
    
    func getRandomNumbers() -> (Int, Int) {
        let objectIndex1 = Int(arc4random_uniform(UInt32(self.records.count)))
        var objectIndex2 = Int(arc4random_uniform(UInt32(self.records.count)))
        
        while objectIndex1 == objectIndex2 {
            objectIndex2 = Int(arc4random_uniform(UInt32(self.records.count)))
        }
        return (objectIndex1, objectIndex2)
    }
    
    func isPetOwner(record: Pet) -> Bool {
        guard let user = PFUser.current()?.objectId else {return false}
        guard let owner = record.owner.objectId else {return false}
        return owner == user
    }
    
    func isDuplicate(record: Pet, atIndex: Int) -> Bool {
        if self.records.count < atIndex {
            print("dumb coder off by 1")
            return true
        }
        let item = self.records[atIndex]
        if item == record {
            print("strictly equal records")
            return true
        }
        if item.imageFile == record.imageFile {
            print("same image")
            return true
        }
        return false
    }
    
    func doesContainRecord(record: Pet) -> Bool {
        
        for pet in records {
            if pet.imageFile == record.imageFile {
                return true
            }
        }
        return false
    }
    
    func replaceRecordAt(record: Pet, index: Int) {

        if self.records.count - 1 <= index {
            self.records[index] = record
        } else {
            print("index out of bounds")
        }
    }
    
    func removeRecordAtIndex(index: Int) -> Pet? {
        if records.count > index {
            return records.remove(at: index)
        }
        return nil
    }
    
    func addRecord(record: Pet) {
        if self.doesContainRecord(record: record) {
            print("attempted to add duplicate to queue")
            return
        }
    }
    
    func fetchTopRecordsForLeaderBoard(maxCount: Int, completion: @escaping (Bool)->()){
        API.fetchTopPets(count: maxCount) { (petRecords) in
            self.records = petRecords
            completion(true)
            return
        }
    }
    
    func fetchUsersPetsForProfile(user: PFUser, completion: @escaping (Bool)->()) {
        API.fetchUsersPets(user: user) { (usersPetRecords) in
            self.records = usersPetRecords
            completion(true)
            return
        }
    }

}
