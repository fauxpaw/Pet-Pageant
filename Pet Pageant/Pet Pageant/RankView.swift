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
    
    //MARK: PROPERTIES
    
    var view: UIView!
    var currentPosition: CGPoint?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votePercentageLabel: UILabel!
    @IBOutlet weak var labelBackgroundView: UIView!
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RankView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    //MARK: INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.commenceAesthetics()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.commenceAesthetics()
    }
    
    //MARK: CLASS METHODS
    
    func setup() {
        view = self.loadXib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func commenceAesthetics() {
//        self.view.layer.borderColor = gThemeColor.cgColor
//        self.view.layer.borderWidth = 5
        self.imageView.layer.cornerRadius = gCornerRadius
        self.imageView.layer.borderColor = gThemeColor.cgColor
        self.imageView.layer.borderWidth = 4
        self.imageView.backgroundColor = gThemeColor
        self.labelBackgroundView.layer.borderWidth = gBorderWidthDefault
        self.labelBackgroundView.layer.borderColor = gThemeColor.cgColor
        self.labelBackgroundView.layer.cornerRadius = gCornerRadius
        self.view.layer.cornerRadius = gCornerRadius
        self.view.layer.borderColor = gThemeColor.cgColor
        self.labelBackgroundView.backgroundColor = gBackGroundColor
        self.votesLabel.textColor = gThemeColor
        self.votePercentageLabel.textColor = gThemeColor
        self.rankLabel.textColor = gThemeColor
        
    }
    
    func coordsToAngle (pos: CGPoint) -> CGFloat {
        let angle = atan2(pos.y - gCarouselCenterPoint.y, pos.x - gCarouselCenterPoint.x)
        return angle
    }
    
    func angleToCoords (angle: CGFloat) -> CGPoint {
        
        //(x,y) = cx + rcos0, cy +sin0
       
       return CGPoint(x: gCarouselCenterPoint.x + (gScreenSize.width/2) * cos(angle), y:gCarouselCenterPoint.y + (gScreenSize.width/2) * sin(angle))
        
    }
    
    func calculateNextPosition (currentAngle: CGFloat, clockwise: Bool) -> CGFloat {
        let distance = 2 * M_PI / Double(gNumberOfRankViews)
        
        if clockwise == true {
            return currentAngle + CGFloat(distance)
        }
        else {
            return currentAngle - CGFloat(distance)
        }
    }
    
    func updateCenterPosition() {
        self.currentPosition = self.center
    }
    
    func viewToFront() {
        self.superview?.bringSubview(toFront: self)
    }
    
    func viewToRear(){
        self.superview?.sendSubview(toBack: self)
    }
    
    func evaluateViewForResize(angle: CGFloat){
        print("angle passed is: \(angle)")
        
        switch round(angle) {
        case -3:
            self.scaleViewDefault()
        case -2:
            self.scaleViewDown()
            self.viewToRear()
        case -1:
            self.scaleViewDown()
            self.viewToRear()
        case 0:
            self.scaleViewDefault()
        case 2:
            self.scaleViewUp()
            self.viewToFront()
        case 3:
            self.scaleViewDefault()
        case 4:
            self.scaleViewDown()
            self.viewToRear()
        default:
            self.scaleViewDefault()
        }
    }
    
    //MARK: ANIMATIONS
    
    func animate(clockwise: Bool) {
       // self.updateCurrentPosition()
        guard let pos = self.currentPosition else { return }
        let startAngle = self.coordsToAngle(pos: pos)
        let endAngle = self.calculateNextPosition(currentAngle: startAngle, clockwise: clockwise)
        let arcPath = UIBezierPath()
        arcPath.addArc(withCenter: gCarouselCenterPoint, radius: gScreenSize.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = arcPath.cgPath
        anim.repeatCount = 1
        anim.duration = gAnimationTime
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        self.layer.add(anim, forKey: "carousel")
        self.evaluateViewForResize(angle: endAngle)
        
        let check =  self.angleToCoords(angle: endAngle)
        self.currentPosition = check
    }
    
    func scaleViewDown() {
        UIView.animate(withDuration: gAnimationTime, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    func scaleViewDefault() {
        UIView.animate(withDuration: gAnimationTime, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    func scaleViewUp() {
        UIView.animate(withDuration: gAnimationTime, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }
}
