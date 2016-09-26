//
//  LeaderboardViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    var viewCenterPositions = [CGPoint]()
    var views = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwipes()
        self.setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupSwipes(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func setupViews() {
        self.views.removeAll()
        for index in 0..<carouselViewCount {
            let angle = CGFloat(90 + index * (360/carouselViewCount))
            let x = carouselCenterPoint.x + CGFloat(screenSize.width/2) * cos(angle * CGFloat(M_PI/180))
            let y = carouselCenterPoint.y + CGFloat(screenSize.width/2) * sin(angle * CGFloat(M_PI/180))
            let position = CGPoint(x: x, y: y)
            let view = RankView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            view.center = position
            self.viewCenterPositions.append(position)
            self.views.append(view)
            self.view.addSubview(view)
            print("Center Positions: \(self.viewCenterPositions)")
        }
    }
    
    func swipeGesture(gesture: UISwipeGestureRecognizer){
        
        if gesture.direction == UISwipeGestureRecognizerDirection.Left{
            CarouselView.rotateViewsClockwise(self, views: self.views, completion: { (success) in
                CarouselView.toggleUserInteractionAfterAnimation(self, views: self.views)
            })
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.Right {
            CarouselView.rotateViewsCounterClockwise(self, views: views, completion: { (success) in
                CarouselView.toggleUserInteractionAfterAnimation(self, views: self.views)
            })
        }
    }
}
