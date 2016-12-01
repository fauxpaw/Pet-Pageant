//
//  TopRankedPet.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class RankView: UIView {
    
    var view: UIView!
    var currentPosition: CGPoint?
    var nextPosition: CGPoint?
    
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
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        UINib(nibName: "RankView", bundle: nil).instantiateWithOwner(self, options: nil)
        self.setup()
    }
    
    func setup() {
        view = self.loadXib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func updateCurrentPosition() {
        if let current = self.currentPosition {
            self.center = current

        } else {
            print("no value found for self.currentPosition")
        }
        //print("\(self.currentPosition)")
        //print("current is \(self.currentPosition) ----> Setting current to \(self.center)")
    }
    
    
    func coordsToAngle (pos: CGPoint) -> CGFloat {
        let angle = atan2(pos.y - carouselCenterPoint.y, pos.x - carouselCenterPoint.x)
        //print(angle)
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
    
    func animate(clockwise: Bool) {
        self.updateCurrentPosition()
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
        let check =  self.angleToCoords(angle: endAngle)
        print("Current position is: \(self.currentPosition)")
        print("Position for next is: \(check)")
        self.currentPosition = check
    }
    
    
    
}
