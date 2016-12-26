//
//  TopRankedPet.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Foundation
class RankView: UIView {
    
    var view: UIView!
    var currentPosition: CGPoint?
    var defaultSize: CGRect?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votePercentageLabel: UILabel!
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RankView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        view = self.loadXib()
        view.frame = self.bounds
        self.defaultSize = view.frame
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func tellMeViewStats(angle: CGFloat) {
        self.rankLabel.text = "My height is: \(self.frame.height)"
        self.votesLabel.text = "My angle is: \(round(angle))"
        self.votePercentageLabel.text = "My position is: \(self.currentPosition)"
    }
    
    func coordsToAngle (pos: CGPoint) -> CGFloat {
        let angle = atan2(pos.y - carouselCenterPoint.y, pos.x - carouselCenterPoint.x)
        return angle
    }
    
    func angleToCoords (angle: CGFloat) -> CGPoint {
        
        //(x,y) = cx + rcos0, cy +sin0
       
       return CGPoint(x: carouselCenterPoint.x + (screenSize.width/2) * cos(angle), y:carouselCenterPoint.y + (screenSize.width/2) * sin(angle))
        
    }
    
    func calculateNextPosition (currentAngle: CGFloat, clockwise: Bool) -> CGFloat {
        let distance = 2 * M_PI / Double(numberOfRankViews)
        
        if clockwise == true {
            return currentAngle + CGFloat(distance)
        }
        else {
            return currentAngle - CGFloat(distance)
        }
    }
    
    //MARK: ANIMATIONS
    func animate(clockwise: Bool) {
       // self.updateCurrentPosition()
        guard let pos = self.currentPosition else { return }
        let startAngle = self.coordsToAngle(pos: pos)
        let endAngle = self.calculateNextPosition(currentAngle: startAngle, clockwise: clockwise)
        let arcPath = UIBezierPath()
        arcPath.addArc(withCenter: carouselCenterPoint, radius: screenSize.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = arcPath.cgPath
        anim.repeatCount = 1
        anim.duration = animationTime
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        self.layer.add(anim, forKey: "carousel")
        self.evaluateViewForResize(angle: endAngle)
        
        let check =  self.angleToCoords(angle: endAngle)
        self.currentPosition = check
      //  self.tellMeViewStats(angle: endAngle)
    }
    
    func scaleViewDown() {
        UIView.animate(withDuration: animationTime, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    func scaleViewDefault() {
        UIView.animate(withDuration: animationTime, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    func scaleViewUp() {
        UIView.animate(withDuration: animationTime, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }
    
    func viewToFront() {
        self.superview?.bringSubview(toFront: self)
    }
    
    func evaluateViewForResize(angle: CGFloat){
       // print("angle passed is: \(angle)")
        
        switch round(angle) {
        case -3:
            self.scaleViewDefault()
        case -2:
            self.scaleViewDown()
        case -1:
            self.scaleViewDown()
        case 0:
            self.scaleViewDefault()
        case 2:
            self.scaleViewUp()
            self.viewToFront()
        case 3:
            self.scaleViewDefault()
        case 4:
            self.scaleViewDown()
        default:
            self.scaleViewDefault()
        }
    }
    
}
