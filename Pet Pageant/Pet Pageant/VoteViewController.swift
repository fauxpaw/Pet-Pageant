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
    
    fileprivate let panThreshold: CGFloat = 4.0
    fileprivate let viewAnimationOutTime = 0.5
    fileprivate let viewAnimationInTime = 0.5
    
    var voteQueue = [Pet]()
    var topViewsRecord = [Pet]() {
        didSet {
            topVoteView.petRecord = topViewsRecord.first
            for pet in topViewsRecord {
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackground(block: { (data: Data?, error) in
                    
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
            bottomVoteView.petRecord = botViewsRecord.first
            for pet in botViewsRecord {
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackground(block: { (data: Data?, error) in
                    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupImageViews()
    }
    
    func setupImageViews() {
        self.topVoteView.petImage = nil
        self.bottomVoteView.petImage = nil
        self.topVoteView.enableReport()
        self.bottomVoteView.enableReport()
        self.topVoteView.spinner.startAnimating()
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
            self.topViewsRecord.append(self.voteQueue.remove(at: objectIndex1))
            self.botViewsRecord.append(self.voteQueue.remove(at: objectIndex2))
        }
        else {
            self.topViewsRecord.append(self.voteQueue.remove(at: objectIndex2))
            self.botViewsRecord.append(self.voteQueue.remove(at: objectIndex1))
        }
    }
    
    //MARK: BACKEND COMMUNICATION
    //get the 2 oldest(update time) records
    func GETPetsForQueue () {
        self.topViewsRecord.removeAll()
        self.botViewsRecord.removeAll()
        self.voteQueue.removeAll()
        let query = PFQuery(className: "Pet")
        query.order(byAscending: "updatedAt")
        query.limit = 100
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                let petObjects = objects as! [Pet]
                for object in petObjects {
                    self.voteQueue.append(object)
                }
                self.chooseRecords()
            }
            else if let error = error {
                let alertController = UIAlertController(title: "ERROR", message: "Could not retrieve data due to \(error.localizedDescription). Please try again", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func updatePetRecords(_ selectedView: UIView, nonselectedView: UIView) {
        if selectedView == self.topVoteView {
            guard let record = self.topViewsRecord.first else { return}
            record.incrementKey("votes")
            record.incrementKey("viewed")
            record.saveInBackground(block: { (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("top record updated")
                }
            })
            guard let record2 = self.botViewsRecord.first else { return }
            record2.incrementKey("viewed")
            record2.saveInBackground(block: { (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("bottom record updated")
                }
            })
        }
        else {
            guard let record = self.botViewsRecord.first else {return}
            record.incrementKey("votes")
            record.incrementKey("viewed")
            record.saveInBackground(block: { (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("bottom record updated")
                }
            })
            guard let record2 = self.topViewsRecord.first else { return }
            record2.incrementKey("viewed")
            record2.saveInBackground(block: { (success, error) in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                else {
                    print("top record updated")
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Handle collision for dual-view pan
        self.topVoteView.isUserInteractionEnabled = false
        self.bottomVoteView.isUserInteractionEnabled = false
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.topVoteView.isUserInteractionEnabled = true
        self.bottomVoteView.isUserInteractionEnabled = true
    }
    
    //MARK: ANIMATIONS
    func animateViewsIn(_ top: UIView, bot: UIView) {
        topVoteView.removeVoteIcon()
        bottomVoteView.removeVoteIcon()
        let startCenter = self.view.center.x
        top.center.x = self.view.frame.width * 2
        bot.center.x = self.view.frame.width * -2
        
        UIView.animate(withDuration: viewAnimationInTime, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            
            top.center.x = startCenter
            bot.center.x = startCenter
            
            }, completion: nil)
    }
    
    func animateViewsOut(_ selectedView: UIView, otherView: UIView){
        
        if selectedView.center.x > self.view.center.x {
            
            UIView.animate(withDuration: viewAnimationOutTime, animations: {
                
                selectedView.center.x = self.view.frame.width * 2
                otherView.center.x = self.view.frame.width * -2
                
            }, completion: { (true) in
                
                selectedView.isUserInteractionEnabled = true
                otherView.isUserInteractionEnabled = true
                selectedView.alpha = 1.0
                otherView.alpha = 1.0
                self.setupImageViews()
            }) 
            
        }
        else if selectedView.center.x < self.view.center.x {
            
            UIView.animate(withDuration: viewAnimationOutTime, animations: {
                
                selectedView.center.x = self.view.frame.width * -2
                otherView.center.x = self.view.frame.width * 2
                
            }, completion: { (true) in
                
                selectedView.isUserInteractionEnabled = true
                otherView.isUserInteractionEnabled = true
                selectedView.alpha = 1.0
                otherView.alpha = 1.0
                self.setupImageViews()
            }) 
        }
    }
    
    //MARK: PAN GESTURE
    func viewWasPanned(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {return}
        guard let superView = sender.view?.superview else {return}
        let translation = sender.translation(in: view)
        var selectedView = VoteView()
        var otherView = VoteView()
        
        if view == topVoteView {
            selectedView = topVoteView
            otherView = bottomVoteView
        }
            
        else if view == bottomVoteView {
            selectedView = bottomVoteView
            otherView = topVoteView
        }
        
        switch sender.state {
        case .began:
            selectedView.addYesVoteIcon()
            otherView.addNoVoteIcon()
            otherView.isUserInteractionEnabled = false
        case .changed:
            if selectedView.petImageView.subviews.count > 0 && otherView.petImageView.subviews.count > 0 {
                let yesIconView = selectedView.petImageView.subviews[0]
                let noIconView = otherView.petImageView.subviews[0]
                selectedView.center.x = superView.center.x + translation.x
                let alphaSet = abs(translation.x) / 100
                yesIconView.alpha = alphaSet
                noIconView.alpha = alphaSet
            }
            
        case .ended:
            guard let superView = view.superview else {return}
            if selectedView.petImageView.subviews.count > 0 {
                let iconView = selectedView.petImageView.subviews[0]
                if iconView.alpha > 0.75 {
                    view.isUserInteractionEnabled = false
                    otherView.isUserInteractionEnabled = false
                    self.updatePetRecords(selectedView, nonselectedView: otherView)
                    self.animateViewsOut(view, otherView: otherView)
                } else {
                    selectedView.center = CGPoint(x: superView.center.x, y: view.center.y)
                    selectedView.alpha = 1.0
                    otherView.alpha = 1.0
                    
                    selectedView.removeVoteIcon()
                    otherView.removeVoteIcon()
                    selectedView.isUserInteractionEnabled = true
                    otherView.isUserInteractionEnabled = true
                }
            }
            
            else {
                selectedView.center = CGPoint(x: superView.center.x, y: view.center.y)
                selectedView.alpha = 1.0
                otherView.alpha = 1.0
                
                selectedView.removeVoteIcon()
                otherView.removeVoteIcon()
                selectedView.isUserInteractionEnabled = true
                otherView.isUserInteractionEnabled = true
                
            }
            
        default:
            print("no action triggered")
            return
        }
    }
}
