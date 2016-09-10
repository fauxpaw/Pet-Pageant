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
    
    var showdownRecords = [Pet]()
    var showdownImages = [UIImage]() {
        didSet {
            if showdownImages.count == 2 {
                self.topVoteView.petImage = showdownImages[0]
                self.bottomVoteView.petImage = showdownImages[1]
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
    
    func setupImageViews() {
        
        self.GETPets()
        self.animateViewsIn(topVoteView, bot: bottomVoteView)
        
    }
    //MARK: BACKEND COMMUNICATION
    //get the 2 oldest(by update time) records
    func GETPets () {
        
        self.showdownImages.removeAll()
        let query = PFQuery(className: "Pet")
        query.orderByAscending("updatedAt")
        query.limit = 2
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                let petObjects = objects as! [Pet]
                print("success in getting \(objects)")
                for object in petObjects {
                    
                    let imageData = object["imageFile"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({ (data: NSData?, error) in
                        
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                        if let image = UIImage(data: data!) {
                            self.showdown.append(image)
                        }
                    })
                    
                }
            }
            else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    func updatePet() {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Handle collision for dual-view pan
        self.topVoteView.userInteractionEnabled = false
        self.bottomVoteView.userInteractionEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupImageViews()
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
                self.animateViewsIn(self.topVoteView, bot: self.bottomVoteView)
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
