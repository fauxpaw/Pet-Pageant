//
//  CarouselView.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/19/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

let animationTime = 1.0
let carouselViewCount = 5

struct CarouselView {
    
    let radianConvert = M_PI/180
    let viewPositions = [CGPoint]()
    
    static func arcClockwiseAnimation(targetView: UIView, startAngle: CGFloat, endAngle: CGFloat) {
        
        let arcPath = UIBezierPath()
        arcPath.addArcWithCenter(carouselCenterPoint, radius: screenSize.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = arcPath.CGPath
        anim.repeatCount = 1
        anim.duration = animationTime
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        targetView.layer.addAnimation(anim, forKey: "carousel")
    }
    
    static func arcCounter_ClockwiseAnimation(targetView: UIView, startAngle: CGFloat, endAngle: CGFloat) {
        
        let arcPath = UIBezierPath()
        arcPath.addArcWithCenter(carouselCenterPoint, radius: screenSize.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = arcPath.CGPath
        anim.repeatCount = 1
        anim.duration = animationTime
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        targetView.layer.addAnimation(anim, forKey: "carousel")
    }
    
    static func rotateViewsClockwise(VC: UIViewController, views: [UIView],completion: (success: Bool) -> ()) {
        for view in views {
            view.userInteractionEnabled = false
        }
        VC.view.userInteractionEnabled = false
        for index in 0..<views.count {
            let radians = CGFloat(M_PI/180)
            let angle = CGFloat((90 + index * (360/carouselViewCount)))
            let endAngle = CGFloat(90 + (index + 1) * (360/carouselViewCount))
            CarouselView.arcClockwiseAnimation(views[index], startAngle: angle * radians, endAngle: endAngle * radians)
        }
        completion(success: true)
    }
    
    static func rotateViewsCounterClockwise(VC: UIViewController, views: [UIView] ,completion: (success: Bool) -> ()) {
        for view in views {
            view.userInteractionEnabled = false
        }
        for index in 0..<views.count {
            let radians = CGFloat(M_PI/180)
            let angle = CGFloat((90 - index * (360/carouselViewCount)))
            let endAngle = CGFloat(90 - (index + 1) * (360/carouselViewCount))
            CarouselView.arcCounter_ClockwiseAnimation(views[index], startAngle: angle * radians, endAngle: endAngle * radians)
        }
        completion(success: true)
    }
    
    static func toggleUserInteractionAfterAnimation(VC: UIViewController ,views: [UIView]){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(animationTime * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            for view in views {
                view.userInteractionEnabled = true
            }
            VC.view.userInteractionEnabled = true
        }
    }
}