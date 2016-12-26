//
//  CarouselView.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/19/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

let carouselViewCount = 5

struct CarouselView {
    
    let radianConvert = M_PI/180
    let viewPositions = [CGPoint]()
    
    static func arcClockwiseAnimation(_ targetView: UIView, startAngle: CGFloat, endAngle: CGFloat) {
        
        let arcPath = UIBezierPath()
        arcPath.addArc(withCenter: carouselCenterPoint, radius: screenSize.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = arcPath.cgPath
        anim.repeatCount = 1
        anim.duration = animationTime
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        targetView.layer.add(anim, forKey: "carousel")
    }
    
    static func arcCounter_ClockwiseAnimation(_ targetView: UIView, startAngle: CGFloat, endAngle: CGFloat) {
        
        let arcPath = UIBezierPath()
        arcPath.addArc(withCenter: carouselCenterPoint, radius: screenSize.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = arcPath.cgPath
        anim.repeatCount = 1
        anim.duration = animationTime
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        targetView.layer.add(anim, forKey: "carousel")
    }
    
    static func rotateViewsClockwise(_ VC: UIViewController, views: inout [UIView],completion: (_ success: Bool) -> ()) {
        for view in views {
            view.isUserInteractionEnabled = false
        }
        
        VC.view.isUserInteractionEnabled = false
        for index in 0..<views.count {
            let radians = CGFloat(M_PI/180)
            let angle = CGFloat((90 + index * (360/carouselViewCount)))
            let endAngle = CGFloat(90 + (index + 1) * (360/carouselViewCount))
            CarouselView.arcClockwiseAnimation(views[index], startAngle: angle * radians, endAngle: endAngle * radians)
        }
        let pop = views.removeLast()
        views.insert(pop, at: 0)
        completion(true)
    }
    
    static func rotateViewsCounterClockwise(_ VC: UIViewController, views: inout [UIView] ,completion: (_ success: Bool) -> ()) {
        for view in views {
            view.isUserInteractionEnabled = false
        }
        for index in 0..<views.count {
            let radians = CGFloat(M_PI/180)
            let angle = CGFloat((90 - index * (360/carouselViewCount)))
            let endAngle = CGFloat(90 - (index + 1) * (360/carouselViewCount))
            CarouselView.arcCounter_ClockwiseAnimation(views[index], startAngle: angle * radians, endAngle: endAngle * radians)
        }
        let pop = views.removeLast()
        views.insert(pop, at: 0)
        completion(true)
    }
    
    static func toggleUserInteractionAfterAnimation(_ VC: UIViewController ,views: [UIView]){
        let delayTime = DispatchTime.now() + Double(Int64(animationTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            for view in views {
                view.isUserInteractionEnabled = true
            }
            VC.view.isUserInteractionEnabled = true
        }
    }
    
}
