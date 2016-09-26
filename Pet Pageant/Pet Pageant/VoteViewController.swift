//
//  VoteViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/20/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class VoteViewController: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var topVoteView: VoteView!
    @IBOutlet weak var bottomVoteView: VoteView!
    
    private let panThreshold: CGFloat = 4.0
    private let viewAnimationOutTime = 0.5
    private let viewAnimationInTime = 0.5
    
    var voteQueue = [Pet]()
    var topViewsRecord = [Pet]() {
        didSet {
            for pet in topViewsRecord {
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackgroundWithBlock({ (data: NSData?, error) in
                    
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if let image = UIImage(data: data!) {
                        self.topVoteView.petImage = image
                    }
                })
            }
        }
    }
    
    var botViewsRecord = [Pet]() {
        didSet {
            for pet in botViewsRecord {
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackgroundWithBlock({ (data: NSData?, error) in
                    
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if let image = UIImage(data: data!) {
                        self.bottomVoteView.petImage = image
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewWasPanned(_:)))
        let bottomPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewWasPanned(_:)))
        self.topVoteView.addGestureRecognizer(topPanGesture)
        self.bottomVoteView.addGestureRecognizer(bottomPanGesture)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupImageViews()
    }
    
    func setupImageViews() {
        self.topVoteView.petImage = nil
        self.bottomVoteView.petImage = nil
        self.GETPetsForQueue()
        self.animateViewsIn(topVoteView, bot: bottomVoteView)
    }
    
    func chooseRecords(){
        if self.voteQueue.isEmpty{
            print("VOTEQUE EMPTY -> Aborting chooseRecords")
            return
        }
        
        let objectIndex1 = Int(arc4random_uniform(UInt32(self.voteQueue.count)))
        var objectIndex2 = Int(arc4random_uniform(UInt32(self.voteQueue.count)))
        while objectIndex1 == objectIndex2 {
            objectIndex2 = Int(arc4random_uniform(UInt32(self.voteQueue.count)))
        }
        if objectIndex1 > objectIndex2 {
            self.topViewsRecord.append(self.voteQueue.removeAtIndex(objectIndex1))
            self.botViewsRecord.append(self.voteQueue.removeAtIndex(objectIndex2))
        }
        else {
            self.topViewsRecord.append(self.voteQueue.removeAtIndex(objectIndex2))
            self.botViewsRecord.append(self.voteQueue.removeAtIndex(objectIndex1))
        }
    }
    
    
    //MARK: BACKEND COMMUNICATION
    //get the 2 oldest(by update time) records
    func GETPetsForQueue () {
        self.topViewsRecord.removeAll()
        self.botViewsRecord.removeAll()
        self.voteQueue.removeAll()
        let query = PFQuery(className: "Pet")
        query.orderByAscending("updatedAt")
        query.limit = 100
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                let petObjects = objects as! [Pet]
                for object in petObjects {
                    self.voteQueue.append(object)
                }
                self.chooseRecords()
            }
            else if let error = error {
                let alertController = UIAlertController(title: "ERROR", message: "Could not retrieve data due to \(error.localizedDescription). Please try again", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func updatePetRecords(selectedView: UIView, nonselectedView: UIView) {
        if selectedView == self.topVoteView {
            guard let record = self.topViewsRecord.first else { return}
            record.incrementKey("votes")
            record.incrementKey("viewed")
            record.saveInBackgroundWithBlock({ (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("record updated")
                }
            })
            guard let record2 = self.botViewsRecord.first else { return }
            record2.incrementKey("viewed")
            record2.saveInBackgroundWithBlock({ (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("record updated")
                }
            })
        }
        else {
            guard let record = self.botViewsRecord.first else {return}
            record.incrementKey("votes")
            record.incrementKey("viewed")
            record.saveInBackgroundWithBlock({ (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("record updated")
                }
            })
            guard let record2 = self.topViewsRecord.first else { return }
            record2.incrementKey("viewed")
            record2.saveInBackgroundWithBlock({ (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("record updated")
                }
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Handle collision for dual-view pan
        self.topVoteView.userInteractionEnabled = false
        self.bottomVoteView.userInteractionEnabled = false
    }
    
    //MARK: ANIMATIONS
    func animateViewsIn(top: UIView, bot: UIView) {
        topVoteView.removeVoteIcon()
        bottomVoteView.removeVoteIcon()
        let startCenter = self.view.center.x
        top.center.x = self.view.frame.width * 2
        bot.center.x = self.view.frame.width * -2
        
        UIView.animateWithDuration(viewAnimationInTime, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            
            top.center.x = startCenter
            bot.center.x = startCenter
            
            }, completion: nil)
    }
    
    func animateViewsOut(selectedView: UIView, otherView: UIView){
        
        if selectedView.center.x > self.view.center.x {
            
            UIView.animateWithDuration(viewAnimationOutTime, animations: {
                
                selectedView.center.x = self.view.frame.width * 2
                otherView.center.x = self.view.frame.width * -2
                
            }) { (true) in
                
                selectedView.userInteractionEnabled = true
                otherView.userInteractionEnabled = true
                selectedView.alpha = 1.0
                otherView.alpha = 1.0
                self.setupImageViews()
            }
            
        }
        else if selectedView.center.x < self.view.center.x {
            
            UIView.animateWithDuration(viewAnimationOutTime, animations: {
                
                selectedView.center.x = self.view.frame.width * -2
                otherView.center.x = self.view.frame.width * 2
                
            }) { (true) in
                
                selectedView.userInteractionEnabled = true
                otherView.userInteractionEnabled = true
                selectedView.alpha = 1.0
                otherView.alpha = 1.0
                self.setupImageViews()
            }
        }
    }
    
    //MARK: PAN GESTURE
    func viewWasPanned(sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view else {return}
        guard let superView = sender.view?.superview else {return}
        let translation = sender.translationInView(view)
        var selectedView = VoteView()
        var otherView = VoteView()
        
        //vote icons
        
        if view == topVoteView {
            selectedView = topVoteView
            otherView = bottomVoteView
        }
            
        else if view == bottomVoteView {
            selectedView = bottomVoteView
            otherView = topVoteView
        }
        
        switch sender.state {
        case .Began:
            selectedView.addYesVoteIcon()
            otherView.addNoVoteIcon()
            otherView.userInteractionEnabled = false
        case .Changed:
            let yesIconView = selectedView.petImageView.subviews[0]
            let noIconView = otherView.petImageView.subviews[0]
            selectedView.center.x = superView.center.x + translation.x
            let alphaSet = abs(translation.x) / 100
            yesIconView.alpha = alphaSet
            noIconView.alpha = alphaSet
        case .Ended:
            guard let superView = view.superview else {return}
            let iconView = selectedView.petImageView.subviews[0]
            if iconView.alpha > 0.75 {
                view.userInteractionEnabled = false
                otherView.userInteractionEnabled = false
                self.updatePetRecords(selectedView, nonselectedView: otherView)
                self.animateViewsOut(view, otherView: otherView)
            }
                
            else {
                selectedView.center = CGPointMake(superView.center.x, view.center.y)
                selectedView.alpha = 1.0
                otherView.alpha = 1.0
                
                selectedView.removeVoteIcon()
                otherView.removeVoteIcon()
                selectedView.userInteractionEnabled = true
                otherView.userInteractionEnabled = true
                
            }
            
        default:
            return
        }
    }
    
    //MARK: ACTIONS
    
}
