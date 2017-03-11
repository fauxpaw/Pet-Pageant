//
//  VoteViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/20/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class VoteViewController: UIViewController, ButtonVotingProtocol {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var topVoteView: VoteView!
    @IBOutlet weak var bottomVoteView: VoteView!
    
    fileprivate let panThreshold: CGFloat = 4.0
    fileprivate let viewAnimationOutTime = 0.4
    fileprivate let viewAnimationInTime = 0.4
    
    fileprivate var voteQueue = [Pet]()
    fileprivate var topViewsRecord = [Pet]() {
        didSet {
            topVoteView.petRecord = topViewsRecord.first
            for pet in topViewsRecord {
                
                weak var weakSelf = self
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackground(block: { (data: Data?, error) in
                    guard let strongSelf = weakSelf else {return}
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if let image = UIImage(data: data!) {
                        strongSelf.topVoteView.petImage = image
                        strongSelf.topVoteView.spinner.hidesWhenStopped = true
                        strongSelf.topVoteView.spinner.stopAnimating()
                    }
                })
            }
        }
    }
    
    fileprivate var botViewsRecord = [Pet]() {
        didSet {
            bottomVoteView.petRecord = botViewsRecord.first
            for pet in botViewsRecord {
                weak var weakSelf = self
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackground(block: { (data: Data?, error) in
                    guard let strongSelf = weakSelf else {return}
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if let image = UIImage(data: data!) {
                        strongSelf.bottomVoteView.petImage = image
                        
                        strongSelf.bottomVoteView.spinner.hidesWhenStopped = true
                        strongSelf.bottomVoteView.spinner.stopAnimating()
                    }
                })
            }
        }
    }
    
    //MARK: VIEWCONTROLLER METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topVoteView.delegate = self
        self.bottomVoteView.delegate = self
        self.setupPanGestures()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupImageViews()
    }
    
    
    //ButtonVoting protocol
    internal func didVoteViaButton(forView: VoteView) {
        
        var otherivew = VoteView()
        
        if(topVoteView == forView){
            otherivew = bottomVoteView
        } else if (bottomVoteView == forView) {
            otherivew = topVoteView
        }
        self.updatePetRecords(forView, nonselectedView: otherivew)
        self.animateViewsOut(forView, otherView: otherivew)        
    }
    
    internal func didPassViaButton(forView: VoteView) {
        var otherivew = VoteView()
        
        if(topVoteView == forView){
            otherivew = bottomVoteView
        } else if (bottomVoteView == forView) {
            otherivew = topVoteView
        }
        
        self.animateViewsOut(forView, otherView: otherivew)
    }
    
    //MARK: CLASS METHODS
    
    fileprivate func setupImageViews() {
        self.topVoteView.petImage = nil
        self.bottomVoteView.petImage = nil
        self.topVoteView.enableReport()
        self.bottomVoteView.enableReport()
        self.topVoteView.spinner.startAnimating()
        self.bottomVoteView.spinner.startAnimating()
        self.GETPetsForQueue()
        self.animateViewsIn(topVoteView, bot: bottomVoteView)
    }
    
    fileprivate func chooseRecords(){
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
    
    /* MARK: BACKEND CALLS
           -- get the 2 oldest(by update time) records --
    */
    
    fileprivate func GETPetsForQueue () {
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
    
    fileprivate func updatePetRecords(_ selectedView: UIView, nonselectedView: UIView) {
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
    
    //To handle collision for dual-view pan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.topVoteView.isUserInteractionEnabled = false
        self.bottomVoteView.isUserInteractionEnabled = false
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.topVoteView.isUserInteractionEnabled = true
        self.bottomVoteView.isUserInteractionEnabled = true
    }
    
    //MARK: ANIMATIONS
    fileprivate func animateViewsIn(_ top: UIView, bot: UIView) {
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
    
    fileprivate func animateViewsOut(_ selectedView: UIView, otherView: UIView){
        
        if selectedView.center.x > self.view.center.x || selectedView.center.x == self.view.center.x {
            
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
    
     fileprivate func setupPanGestures(){
        let topPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewWasPanned(_:)))
        let bottomPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewWasPanned(_:)))
        self.topVoteView.addGestureRecognizer(topPanGesture)
        self.bottomVoteView.addGestureRecognizer(bottomPanGesture)
    }
    
     public func viewWasPanned(_ sender: UIPanGestureRecognizer) {
        
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
                guard let yesIconView = selectedView.voteIcon else { return }
                guard let noIconView = otherView.voteIcon else { return }
                selectedView.center.x = superView.center.x + translation.x
                let alphaSet = abs(translation.x) / 100
                yesIconView.alpha = alphaSet
                noIconView.alpha = alphaSet
            
        case .ended:
            
            guard let superView = view.superview else {return}
            guard let iconView = selectedView.voteIcon else { return }
            
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
            
        default:
            print("no action triggered")
            return
        }
    }
}
