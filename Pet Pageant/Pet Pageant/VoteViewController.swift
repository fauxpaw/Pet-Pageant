//
//  VoteViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/20/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit


class VoteViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var topVoteView: UIView!
    @IBOutlet weak var bottomVoteView: UIView!
    let panThreshold: CGFloat = 4.0
    let viewAnimationOutTime = 0.5
    let viewAnimationInTime = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewWasPanned(_:)))
        let bottomPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewWasPanned(_:)))
        self.topVoteView.addGestureRecognizer(topPanGesture)
        self.bottomVoteView.addGestureRecognizer(bottomPanGesture)
        
    }
    
    func setupImageViews() {
        
        //TODO: GET IMAGE
        print("got/set image")
        //TODO: SET IMAGE
        self.animateViewsIn(topVoteView, bot: bottomVoteView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupImageViews()
    }
    
    func hideViews(top: UIView, bot: UIView){
        
        top.hidden = true
        bot.hidden = true
        
    }
    
    func showViews(top: UIView, bot: UIView) {
        
        top.hidden = false
        bot.hidden = false
        
    }
    
    func animateViewsIn(top: UIView, bot: UIView) {
        
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
    
    func viewWasPanned(sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view else {return}
        guard let superView = sender.view?.superview else {return}
        let translation = sender.translationInView(view)
        var otherView = UIView()
        
        if view == topVoteView {
            otherView = bottomVoteView
        }
            
        else if view == bottomVoteView {
            otherView = topVoteView
        }
        
        switch sender.state {
        case .Began:
            print("began")
        case .Changed:
            view.center.x = superView.center.x + translation.x
            let alphaSet = ((100 - abs(translation.x)) / 100)
            view.alpha = alphaSet
            otherView.alpha = alphaSet
        case .Ended:
            guard let superView = view.superview else {return}
            
            if view.alpha < 0.55 {
                //TODO: call function to animate selected view out, hide other view, reset voteview
                view.userInteractionEnabled = false
                otherView.userInteractionEnabled = false
                self.animateViewsOut(view, otherView: otherView)
            }
                
            else {
                view.center = CGPointMake(superView.center.x, view.center.y)
                view.alpha = 1.0
                otherView.alpha = 1.0
                //TODO: remove the checkmark etc
            }
            
        default:
            return
        }
    }
    
    //MARK: ACTIONS
    
}
